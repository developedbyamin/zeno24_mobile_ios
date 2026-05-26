import Foundation

/// Tolerant string decoder: the backend sometimes returns `false` (a JSON
/// boolean) when a string-typed field like `email` is unset. Decoding such a
/// value into `String?` would throw, so this helper accepts string, `Bool`
/// (treated as `nil`), and `null` interchangeably. Mirrors the Flutter
/// project's `SafeDecodingHook` used in the user-data flow.
enum SafeString {
    static func decode<K: CodingKey>(
        _ container: KeyedDecodingContainer<K>,
        forKey key: K
    ) throws -> String? {
        if let s = try? container.decodeIfPresent(String.self, forKey: key) {
            return s
        }
        // Accept (and discard) Bool/Int placeholders so a quirky server
        // response doesn't blow up the whole settings decode.
        if (try? container.decodeIfPresent(Bool.self, forKey: key)) != nil { return nil }
        if let n = try? container.decodeIfPresent(Int.self, forKey: key) { return String(n) }
        return nil
    }
}
