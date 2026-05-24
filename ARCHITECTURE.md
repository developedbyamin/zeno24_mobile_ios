# zeno24 iOS — Texniki Seçimlər (Architecture Guide)

Bu sənəd zeno24 iOS native layihəsi üçün **network**, **storage** və **state management** sahələrində tövsiyə olunan kitabxanaları və yanaşmaları izah edir. Hər bölmədə "Niyə bu seçim?" və "Necə istifadə etməli?" cavabları var.

**Minimum target**: iOS 17+ (Swift 5.9+, Swift Concurrency və `@Observable` makrosu üçün).

---

## 1. State Management

### Tövsiyə: SwiftUI `@Observable` + `@Environment` injection

iOS 17-dən başlayaraq Apple yeni `Observation` framework-ünü təqdim etdi. Bu, Flutter-də Provider/Riverpod-un ekvivalentidir — amma **heç bir third-party kitabxana lazım deyil**.

```swift
@MainActor
@Observable
final class AuthStore {
    var state: AuthState = .loading
    var errorMessage: String?

    func login(...) async { ... }
}
```

View-da istifadə:
```swift
struct SignInView: View {
    @Environment(AuthStore.self) private var auth
    // ...
}
```

Root-da injection:
```swift
WindowGroup {
    RootView()
        .environment(authStore)
        .environment(settingsStore)
}
```

### Niyə bu, daha yaxşıdır?

| Variant | Niyə yox? |
|---|---|
| `ObservableObject` + `@Published` | iOS 16-dan sonra **köhnəlmiş** sayılır. Hər `@Published` dəyişəndə bütün view yenidən render olur, performance pisdir. |
| ReSwift / TCA (The Composable Architecture) | TCA güclüdür amma **çox boilerplate** tələb edir. Kiçik/orta layihələr üçün overkill. Komanda bütün bu pattern-i öyrənməlidir. |
| Combine | Apple Combine-i deprecation yoluna salır. Yeni kod `async/await` + `@Observable` istifadə etməlidir. |
| Redux/MobX patterns | Swift world-də natural deyil, ecosystem dəstəyi zəifdir. |

### Best Practices

1. **Hər store-un yalnız bir məsuliyyəti olmalıdır**: `AuthStore`, `SettingsStore`, `CirclesStore` — ümumi "AppStore" yaratma.
2. **`@MainActor` qoy**: UI state həmişə main thread-də olmalıdır.
3. **`async` metodlar**: callback / Combine əvəzinə `async throws` istifadə et.
4. **Store-da business logic** olsun, **View-da yalnız reaktiv binding** — store-a `.action()` çağırışı.
5. **Dependency injection**: store-un constructor-undan repository qəbul et — test üçün mock əvəz edə biləsən.

---

## 2. Network Layer

### Tövsiyə: Native `URLSession` + `async/await` + custom `APIClient`

Layihəmizdə artıq qurulmuş [APIClient](zeno24/Core/Network/APIClient.swift) varianti tövsiyə olunur.

```swift
let user: SettingsResponseModel = try await apiClient.get("/settings/me")
let result: SignStep2ResponseModel = try await apiClient.post("/auth/step2", body: req)
```

### Niyə Alamofire/Moya yox?

| Kitabxana | Status |
|---|---|
| **Alamofire** | Hələ də populyardır, amma `async/await` URLSession-da artıq native dəstəkləndiyindən **çox şey qazandırmır**. Əlavə dependency, app size +1MB. |
| **Moya** | Alamofire üzərindədir, target-based API gözəldir amma overhead artırır. |
| **AsyncHTTPClient** (swift-server) | Server-side üçündür, iOS-da yox. |

URLSession + custom client-in üstünlükləri:
- ✅ Apple-ın rəsmi tövsiyəsi
- ✅ Dependency yox, app size dəyişmir
- ✅ Tam control: retry, caching, certificate pinning, background tasks
- ✅ `URLSession.shared.data(for:)` ilə async hazırdır

### Vacib komponentlər

#### 2.1. Retry + Token Refresh Interceptor (əlavə edilməli)

401 alınanda refresh token-i istifadə edib retry etmək lazımdır:

```swift
extension APIClient {
    private func performWithRefresh<T: Decodable>(_ request: URLRequest) async throws -> T {
        do {
            return try await perform(request)
        } catch APIError.unauthorized {
            try await refreshAccessToken()
            var newRequest = request
            AuthInterceptor.apply(to: &newRequest, tokens: authTokens)
            return try await perform(newRequest)
        }
    }
}
```

#### 2.2. Reachability

Şəbəkə statusunu izləmək üçün `NWPathMonitor` (Network framework):
```swift
import Network

@Observable
final class NetworkMonitor {
    var isOnline: Bool = true
    private let monitor = NWPathMonitor()

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in self?.isOnline = path.status == .satisfied }
        }
        monitor.start(queue: .global())
    }
}
```

#### 2.3. JSON Decoding

- `JSONDecoder` ilə `keyDecodingStrategy = .convertFromSnakeCase` (artıq qurulub)
- `dateDecodingStrategy = .iso8601` (artıq qurulub)
- Server `null` qaytararsa `Optional` istifadə et — Flutter-dakı `mapper.dart` analoqu lazım deyil, Swift compile-time type-safe-dir.

### Real-Time Bağlantı (Markers Sync üçün)

`MarkersStore.startSyncing` polling istifadə edir. Daha effektiv variant:

| Yanaşma | Tövsiyə |
|---|---|
| **WebSocket** (`URLSessionWebSocketTask`) | ✅ Real-time tracking üçün ən yaxşısı. Native dəstək var. |
| **Server-Sent Events (SSE)** | ✅ Yalnız server→client lazımdırsa daha yüngül variant. |
| **Polling (5s interval)** | ⚠️ Battery-yə pis təsir edir. Yalnız fallback kimi. |
| **Firebase Realtime DB / Firestore** | ✅ Backend Firebase-dədirsə pulsuz. |

Tövsiyə: `URLSessionWebSocketTask` ilə custom Swift wrapper.

---

## 3. Storage

### 3 fərqli storage layer-i lazımdır:

| Layer | Nə üçün? | Tövsiyə |
|---|---|---|
| **Secure (Keychain)** | Token, password, sensitive | [`SecureStorage`](zeno24/Core/Utils/Storage/SecureStorage.swift) — artıq qurulub ✅ |
| **Preferences** | Theme, dil, user defaults | `UserDefaults` |
| **Database** | Cache, offline data, böyük datasets | **SwiftData** |

### 3.1. Token Storage — Keychain ✅

Keychain Apple-ın security framework-üdür. **Flutter Secure Storage-in iOS implementasiyası da məhz Keychain üzərindədir.**

✅ Layihəmizdə artıq `SecureStorage.swift` Keychain wrapper kimi qurulub.

**Niyə UserDefaults yox?**
- UserDefaults plain text-dədir
- Backup-a düşür və başqa app-lardan oxuna bilər (jailbreak-li cihazda)
- Token / şifrə üçün təhlükəsizlik standartı pozulur

### 3.2. Preferences — `UserDefaults`

Sadə key-value pair-lar üçün:
- Dil seçimi (`LocaleStore`)
- Theme mode (`ThemeStore`)
- Onboarding tamamlandı/yox flag-i
- Tutorial göstərildi/yox

```swift
UserDefaults.standard.set("az", forKey: "app.language_code")
```

### 3.3. Database / Cache — **SwiftData** (iOS 17+) tövsiyə olunur

**SwiftData** = Core Data-nın yeni, Swift-native variantı. Apple-ın 2023-də təqdim etdiyi rəsmi həll.

```swift
import SwiftData

@Model
final class CachedCircle {
    @Attribute(.unique) var id: String
    var name: String
    var memberCount: Int
    var updatedAt: Date

    init(id: String, name: String, memberCount: Int, updatedAt: Date) {
        self.id = id
        self.name = name
        self.memberCount = memberCount
        self.updatedAt = updatedAt
    }
}
```

App-da:
```swift
WindowGroup {
    RootView()
}
.modelContainer(for: [CachedCircle.self, CachedMessage.self])
```

### Niyə SwiftData?

| Variant | Qiymət |
|---|---|
| **SwiftData** | ✅ Apple-ın yeni rəsmi həllidir. Swift-native, `@Model` macro ilə minimum boilerplate. CloudKit sync ilə avtomatik inteqrasiya. |
| **Core Data** | ⚠️ Hələ də güclüdür amma SwiftData onun üstündə qurulub. Yeni layihələrdə SwiftData tövsiyə olunur. |
| **Realm** | ⚠️ MongoDB satın aldı, gələcəyi qeyri-müəyyəndir. Vendor lock-in. |
| **GRDB** (SQLite) | ✅ Çox sürətlidir, professional layihələr üçün gözəldir. Amma SwiftData-dan **çətindir**. |
| **JSON faylda saxlamaq** | ❌ Yalnız çox kiçik datasets üçün uyğundur. |

**Nə vaxt GRDB seçim?**
- Çox böyük dataset (100k+ row)
- Mürəkkəb SQL query-lər
- Tam control + sürət lazımdır

zeno24 ölçüsündə **SwiftData kifayətdir**.

### 3.4. Image Cache

Avatar və circle şəkilləri üçün:

```swift
import SwiftUI

AsyncImage(url: URL(string: avatarUrl)) { image in
    image.resizable()
} placeholder: {
    Circle().fill(.gray)
}
```

`AsyncImage` Apple-ın native həllidir — memory cache var, amma disk cache yoxdur.

**Disk cache lazımdırsa**:
- **Kingfisher** — ən populyar Swift image cache kitabxanası
- **Nuke** — yüksək performance

zeno24 üçün başlanğıcda `AsyncImage` kifayət edər, çox şəkil göstərəndə Kingfisher əlavə edə bilərsən.

---

## 4. Dependency Injection

### Tövsiyə: Manual DI + `@Environment`

Layihəmizdə artıq qurulan model:
1. [`ServiceLocator`](zeno24/App/ServiceLocator.swift) — non-view layer üçün shared instances
2. `@Environment` — view layer üçün store injection

```swift
@State private var authStore = AuthStore(
    repository: ServiceLocator.shared.authRepository
)
```

### Niyə Resolver/Swinject yox?

- Kiçik/orta layihələrdə **manual DI sadədir və izlənilir** (traceable)
- Compile-time error verir (kitabxana ilə runtime crash ola bilər)
- Test üçün constructor-da mock vermək kifayətdir
- Heç bir dependency artımı yoxdur

---

## 5. Logging

### Tövsiyə: `OSLog` (`os.Logger`)

Apple-ın rəsmi logging sistemidir. Console.app və Xcode-da görünür.

```swift
import OSLog

private let logger = Logger(subsystem: "com.zeno24", category: "auth")
logger.debug("User logged in: \(userId, privacy: .public)")
logger.error("API call failed: \(error.localizedDescription)")
```

**Niyə print() yox?**
- `print()` release build-də də işləyir → performance pis
- Filter-leyə bilmirsən
- Privacy mode yoxdur

---

## 6. Async / Concurrency

### Qaydalar:

1. **`async/await` istifadə et** — heç vaxt yeni kodda completion handler / closure-callback yazma.
2. **`@MainActor` qoy**: UI state dəyişən hər metoda.
3. **`Task {}` ilə fire-and-forget**, `Task.detached` yalnız UI-dan ayrı işlər üçün.
4. **`actor` istifadə et** — paylaşılan mutable state üçün (məs. cache, queue).
5. **Cancellation-i unutma**: `Task` cancellation-a hörmət et:
   ```swift
   for await item in stream {
       try Task.checkCancellation()
       process(item)
   }
   ```

### Combine-dən qaçın

Combine hələ də işləyir, amma:
- Apple yeni feature-lər əlavə etmir
- `async/await` daha sadə, type-safe və idiomatik-dir
- `AsyncSequence` Combine-in `Publisher`-inin alternatividir

---

## 7. Routing / Navigation

### Tövsiyə: `NavigationStack(path:)` + typed `AppRoute` enum

iOS 16+-də Apple yeni NavigationStack-i təqdim etdi. Programmatic navigation üçün lazım olan budur.

✅ Layihəmizdə artıq [`AppRouter`](zeno24/Core/Router/AppRouter.swift) + [`AppRoute`](zeno24/Core/Router/AppRoute.swift) qurulub.

**Niyə bu yaxşıdır?**
- Type-safe route-lar (compile-time error)
- Deep link-lər asanlıqla mapping olunur
- Test edilə bilər
- Apple-ın native API-sidir

### Niyə Coordinator pattern + UIKit yox?

UIKit Coordinator-lar SwiftUI ilə uyğun deyil. SwiftUI-da `NavigationStack` + `@Observable` router kifayətdir.

---

## 8. Localization

### Tövsiyə: Native `Localizable.strings` + String Catalog (`.xcstrings`)

iOS 17+-də Apple **String Catalog** (`.xcstrings`) təqdim etdi — `Localizable.strings`-in JSON-based varianti. Xcode-da GUI ilə bütün dilləri idarə edə bilərsən.

```swift
Text("auth.signIn.title")  // SwiftUI avtomatik localize edir
"auth.signIn.title".localized  // String extension ilə
```

✅ Layihəmizdə artıq [`LocalizationExtension`](zeno24/Localization/LocalizationExtension.swift) qurulub.

**Niyə kitabxana yox?**
- Apple-ın native dəstəyi tam kifayətdir
- Xcode 15+ ilə GUI editor var
- Çoxdilli `.xcstrings` faylı versiyalı saxlanır

---

## 9. Analytics & Crash Reporting

### Tövsiyə kombinasiya:

| Məqsəd | Variant |
|---|---|
| **Crash reporting** | Firebase Crashlytics (pulsuz) |
| **Analytics** | Firebase Analytics + Mixpanel/Amplitude |
| **Performance monitoring** | Firebase Performance |
| **Native Apple solution** | MetricKit (iOS 13+) — pulsuz, App Store Connect-də göstərir |

zeno24 Flutter tərəfində Firebase istifadə edirsə, iOS native-də də Firebase SDK-larını qoş.

---

## 10. Testing

### Tövsiyə:

| Növ | Framework |
|---|---|
| **Unit tests** | XCTest (iOS 17-də `Swift Testing` da var, amma hələ stable deyil) |
| **UI tests** | XCUITest |
| **Snapshot tests** | swift-snapshot-testing (Point-Free) |
| **Mocking** | Manual mock (protokol-based) — Mockingbird/Cuckoo lazım deyil |

Test üçün repository-lərin protocol-lərini yarat:
```swift
protocol AuthRepositoryProtocol {
    func login(...) async throws -> ...
}

final class MockAuthRepository: AuthRepositoryProtocol { ... }
```

---

## 11. Layihəyə Əlavə Edilməli Olanlar (TODO)

Bu layihədə hələ yoxdur, amma əlavə edilməsi tövsiyə olunur:

- [ ] **NetworkMonitor** — `NWPathMonitor` wrapper
- [ ] **Token refresh interceptor** — 401 olduqda automatic retry
- [ ] **SwiftData models** — cache layer (CachedCircle, CachedMarker)
- [ ] **WebSocket client** — live markers sync (polling-i əvəz et)
- [ ] **AsyncImage cache layer** — Kingfisher və ya custom
- [ ] **Firebase SDK-ları** — Auth, Analytics, Crashlytics, Cloud Messaging
- [ ] **String Catalog** — `Localizable.xcstrings` faylı (az/en/ru/tr)
- [ ] **Repository protocols** — testability üçün
- [ ] **MapKit configuration** — custom annotation views, clustering
- [ ] **Push notification setup** — APNs + UNUserNotificationCenter handler

---

## 12. SPM Package Dependencies (tövsiyə)

Layihəyə əlavə edilməsi tövsiyə olunan minimum kitabxanalar (Swift Package Manager ilə):

```
// Firebase (əgər backend Firebase-dədirsə)
https://github.com/firebase/firebase-ios-sdk
  - FirebaseAuth
  - FirebaseAnalytics
  - FirebaseCrashlytics
  - FirebaseMessaging

// Disk image cache (lazım gəlsə)
https://github.com/onevcat/Kingfisher

// Snapshot testing
https://github.com/pointfreeco/swift-snapshot-testing
```

**Native ilə qənaət edilənlər (kitabxana lazım deyil):**
- ❌ Alamofire → URLSession kifayətdir
- ❌ SwiftyJSON → Codable kifayətdir
- ❌ ReactiveSwift/RxSwift → async/await kifayətdir
- ❌ SnapKit → SwiftUI auto-layout var
- ❌ R.swift → SwiftGen / String Catalog kifayətdir
- ❌ Resolver/Swinject → manual DI kifayətdir

---

## Yekun: Tech Stack Cədvəli

| Layer | Seçim | Status |
|---|---|---|
| **State management** | `@Observable` + `@Environment` | ✅ Qurulub |
| **Network HTTP** | `URLSession` + custom `APIClient` | ✅ Qurulub |
| **Real-time** | `URLSessionWebSocketTask` | ⏳ Əlavə ediləcək |
| **Secure storage** | Keychain (`SecureStorage`) | ✅ Qurulub |
| **Preferences** | `UserDefaults` | ✅ İstifadə olunur |
| **Database/Cache** | SwiftData | ⏳ Əlavə ediləcək |
| **Image cache** | `AsyncImage` (sonra Kingfisher) | ⏳ Sonra |
| **DI** | Manual + `ServiceLocator` + `@Environment` | ✅ Qurulub |
| **Routing** | `NavigationStack(path:)` + `AppRoute` | ✅ Qurulub |
| **Localization** | String Catalog (`.xcstrings`) | ⏳ Əlavə ediləcək |
| **Logging** | `OSLog` (`os.Logger`) | ✅ Qurulub |
| **Concurrency** | Swift `async/await` + `actor` | ✅ İstifadə olunur |
| **Analytics/Crash** | Firebase | ⏳ Əlavə ediləcək |
| **Testing** | XCTest + protocol mocks | ⏳ Sonra |

---

**Yekun fəlsəfə**:
> "Apple-ın native həllini götür, kitabxananı yalnız zərurət olduqda əlavə et."

Bu yanaşma:
- App size-i kiçik saxlayır
- iOS update-lərində problem yaratmır
- Maintenance asandır
- Yeni komanda üzvləri Apple sənədindən öyrənə bilər
