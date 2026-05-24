import Foundation

/// Network logger — mirrors dio_logger.dart
enum Logger {
    static func logRequest(_ request: URLRequest) {
        #if DEBUG
        let method = request.httpMethod ?? "?"
        let url = request.url?.absoluteString ?? ""
        print("➡️ \(method) \(url)")

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("   Headers: \(prettyHeaders(headers))")
        }
        if let body = request.httpBody, !body.isEmpty {
            print("   Body: \(prettyBody(body))")
        }
        #endif
    }

    static func logResponse(_ response: URLResponse?, data: Data) {
        #if DEBUG
        guard let http = response as? HTTPURLResponse else { return }
        let url = http.url?.absoluteString ?? ""
        print("⬅️ \(http.statusCode) \(url)")

        if !data.isEmpty {
            print("   Body: \(prettyBody(data))")
        }
        #endif
    }

    static func logError(_ error: Error, request: URLRequest, response: URLResponse? = nil, data: Data? = nil) {
        #if DEBUG
        let method = request.httpMethod ?? "?"
        let url = request.url?.absoluteString ?? ""
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        let status = statusCode.map(String.init) ?? "—"
        print("❌ \(status) \(method) \(url) — \(error)")
        if let data, !data.isEmpty {
            print("   Body: \(prettyBody(data))")
        }
        #endif
    }

    // MARK: - Helpers

    private static func prettyHeaders(_ headers: [String: String]) -> String {
        headers
            .sorted { $0.key < $1.key }
            .map { "\($0.key): \($0.value)" }
            .joined(separator: ", ")
    }

    private static func prettyBody(_ data: Data) -> String {
        if let json = try? JSONSerialization.jsonObject(with: data),
           let pretty = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys]),
           let text = String(data: pretty, encoding: .utf8) {
            return text
        }
        return String(data: data, encoding: .utf8) ?? "<\(data.count) bytes>"
    }
}
