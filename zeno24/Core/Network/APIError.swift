import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case unauthorized
    case forbidden
    case notFound
    case server(Int, String?)
    /// Backend-shaped error: HTTP 200/500 with body `{status: "error", error_code, description}`.
    case backend(code: Int?, description: String?)
    case decoding(Error)
    case network(Error)
    case unknown

    static func fromStatus(_ code: Int, data: Data) -> APIError {
        let message = String(data: data, encoding: .utf8)
        switch code {
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 400..<500: return .server(code, message)
        case 500..<600: return .server(code, message)
        default: return .unknown
        }
    }

    var errorDescription: String? {
        switch self {
        case .invalidURL:        return "Invalid URL"
        case .invalidResponse:   return "Invalid response"
        case .unauthorized:      return "Unauthorized"
        case .forbidden:         return "Forbidden"
        case .notFound:          return "Not found"
        case .server(let c, _):  return "Server error (\(c))"
        case .backend(let code, let desc):
            if let desc, !desc.isEmpty { return desc }
            if let code { return "Error (\(code))" }
            return "Unknown error"
        case .decoding:          return "Failed to decode response"
        case .network:           return "Network error"
        case .unknown:           return "Unknown error"
        }
    }
}

extension Notification.Name {
    static let sessionExpired = Notification.Name("com.zeno24.session.expired")
}
