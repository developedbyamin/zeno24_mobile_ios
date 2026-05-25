import Foundation

enum AuthInterceptor {
    static func apply(to request: inout URLRequest, tokens: AuthTokens) {
        if let token = tokens.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.setValue(Locale.current.identifier, forHTTPHeaderField: "Accept-Language")
        request.setValue("ios", forHTTPHeaderField: "X-Platform")
    }
}
