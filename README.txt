═══════════════════════════════════════════════════════════════════════
  ZENO24 — UNIVERSAL LINK / APP LINK BACKEND TƏLƏBLƏRİ
═══════════════════════════════════════════════════════════════════════

Bu qovluqda 3 fayl var:
  1. README.txt                          → bu fayl (təlimat)
  2. apple-app-site-association          → iOS Universal Link konfiq
  3. assetlinks.json                     → Android App Link konfiq

───────────────────────────────────────────────────────────────────────
  APP-IN HAZIRKI KONFİQURASİYASI
───────────────────────────────────────────────────────────────────────
  Domain               : zeno24.com
  iOS Bundle ID        : com.zenocompany.zeno24
  Apple Team ID        : BYU8YV7643
  Android Package      : com.zenocompany.zeno24
  URL Path             : /api/join
  URL Format           : https://zeno24.com/api/join?code=171918
  Alternativ format    : https://zeno24.com/api/join?data[code]=171918
  URL Scheme fallback  : zeno24://invite?code=171918

───────────────────────────────────────────────────────────────────────
  1. iOS — apple-app-site-association (AASA)
───────────────────────────────────────────────────────────────────────

DEPLOY:
  URL          : https://zeno24.com/.well-known/apple-app-site-association
  Content-Type : application/json
  Uzantı       : YOXDUR (.json əlavə ETMƏ!)
  HTTP redirect: QADAĞAN (Apple izləmir — birbaşa 200 OK olmalıdır)
  HTTPS        : valid certificate

DİQQƏT:
  • Fayl `.json` uzantısı OLMAMALIDIR.
  • 301/302 redirect QADAĞANDIR — Apple AASA-nı izləmir.
  • Cache-Control max-age=3600 maksimum tövsiyə olunur
    (Apple CDN-də cache edir, dəyişiklik 24-48 saata qədər çəkə bilər).

───────────────────────────────────────────────────────────────────────
  2. Android — assetlinks.json
───────────────────────────────────────────────────────────────────────

DEPLOY:
  URL          : https://zeno24.com/.well-known/assetlinks.json
  Content-Type : application/json
  HTTPS        : MƏCBURİ (Android 12+ HTTP qəbul etmir)

VACİB:
  Fayl daxilində iki SHA-256 fingerprint PLACEHOLDER var:
    <UPLOAD_KEY_SHA256>
    <PLAY_SIGNING_KEY_SHA256>

  Bunlar Play Console-dan və lokal keystore-dan götürülməlidir:

  (a) Upload key SHA-256 (lokal keystore):
      keytool -list -v \
        -keystore /Users/amin/keystores/zeno24-upload-key.jks \
        -alias upload
      # password: Zeno24Upload2026!
      # output-dan "SHA256:" sətrini götür

  (b) Play App Signing key SHA-256:
      Google Play Console → zeno24 app → Release → Setup
      → App Integrity → "App signing key certificate"
      → SHA-256 certificate fingerprint kopyala

  HƏR İKİSİ ARRAY-DA OLMALIDIR — yoxsa Play Store-dan yüklənən app
  Universal Link təsdiqindən keçmir.

───────────────────────────────────────────────────────────────────────
  3. /api/join ENDPOINT-İ (mövcud, sadəcə təsdiq)
───────────────────────────────────────────────────────────────────────

  Universal Link təsdiqlənsə də, `/api/join` URL HƏLƏ DƏ HTML cavab
  verməlidir — istifadəçi app quraşdırmayıbsa landing page görsün:

  ┌─ Hal ────────────────────────┬─ Backend cavabı ────────────────┐
  │ iOS/Android user, app var    │ Sistem AASA/assetlinks oxuyur,  │
  │                               │ app açılır — backend çağırılmır │
  ├──────────────────────────────┼─────────────────────────────────┤
  │ Brauzer, app yoxdur          │ Landing page: "Open in app" +   │
  │                               │ App Store / Play Store linkləri │
  ├──────────────────────────────┼─────────────────────────────────┤
  │ Bot / crawler                │ OG meta tags ilə HTML (preview) │
  └──────────────────────────────┴─────────────────────────────────┘

───────────────────────────────────────────────────────────────────────
  4. VERİFİKASİYA (DEPLOY-DAN SONRA)
───────────────────────────────────────────────────────────────────────

  # iOS AASA
  curl -I https://zeno24.com/.well-known/apple-app-site-association
  # gözlənilən: 200 OK, Content-Type: application/json, redirect yox

  # Apple rəsmi yoxlama tool-u (browser):
  https://search.developer.apple.com/appsearch-validation-tool/

  # Android assetlinks
  curl https://zeno24.com/.well-known/assetlinks.json

  # Google rəsmi yoxlama tool-u (browser):
  https://developers.google.com/digital-asset-links/tools/generator
  # Hosting site domain: zeno24.com
  # App package name:    com.zenocompany.zeno24
  # App package fingerprint (SHA256): <hər bir fingerprint üçün ayrı yoxla>

  # Cihazda yoxlama (Android, app install olduqdan sonra):
  adb shell pm get-app-links com.zenocompany.zeno24
  # gözlənilən state: "verified"

───────────────────────────────────────────────────────────────────────
  5. TƏLİMATLARIN QISA XÜLASƏSİ
───────────────────────────────────────────────────────────────────────

  ✓ apple-app-site-association faylını host et (uzantısız, JSON)
  ✓ assetlinks.json faylına 2 SHA-256 fingerprint yazıb host et
  ✓ /api/join endpoint HTML landing page qaytarsın (app olmayanda)
  ✓ Hər iki fayl üçün HTTPS valid certificate məcburi
  ✓ AASA üçün redirect QADAĞAN

═══════════════════════════════════════════════════════════════════════
