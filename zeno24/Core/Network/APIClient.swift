import Foundation

/// Thin URLSession wrapper — mirrors lib/core/network/custom_dio/custom_dio.dart
/// Applies auth + logging interceptors and decodes JSON.
final class APIClient {
    private let session: URLSession
    private let baseURL: URL
    private let authTokens: AuthTokens
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(
        authTokens: AuthTokens,
        baseURL: URL = URL(string: APIPaths.baseURL)!,
        session: URLSession = .shared
    ) {
        self.authTokens = authTokens
        self.baseURL = baseURL
        self.session = session

        let dec = JSONDecoder()
        dec.keyDecodingStrategy = .convertFromSnakeCase
        dec.dateDecodingStrategy = .iso8601
        self.decoder = dec

        let enc = JSONEncoder()
        enc.keyEncodingStrategy = .convertToSnakeCase
        enc.dateEncodingStrategy = .iso8601
        self.encoder = enc
    }

    // MARK: GET
    func get<T: Decodable>(_ path: String, query: [String: String] = [:]) async throws -> T {
        let request = try buildRequest(path: path, method: "GET", query: query, body: Optional<Empty>.none)
        return try await perform(request)
    }

    // MARK: POST
    func post<T: Decodable, B: Encodable>(_ path: String, body: B) async throws -> T {
        let request = try buildRequest(path: path, method: "POST", body: body)
        return try await perform(request)
    }

    // MARK: PUT
    func put<T: Decodable, B: Encodable>(_ path: String, body: B) async throws -> T {
        let request = try buildRequest(path: path, method: "PUT", body: body)
        return try await perform(request)
    }

    // MARK: DELETE
    func delete<T: Decodable>(_ path: String) async throws -> T {
        let request = try buildRequest(path: path, method: "DELETE", body: Optional<Empty>.none)
        return try await perform(request)
    }

    // MARK: - AppRequest/AppResponse envelope

    /// Wraps `data` in `AppRequestModel`, POSTs it, and decodes the
    /// response as `AppResponseModel<R>`. Mirrors Flutter's per-service
    /// `_dio.post(path, data: AppRequestModel(...).toMap())` pattern.
    /// Pass `authenticated: true` to include the access token in the body
    /// (Flutter does this for circles / settings; auth endpoints omit it).
    func send<D: Encodable, R: Decodable>(
        _ path: String,
        data: D,
        authenticated: Bool = false
    ) async throws -> AppResponseModel<R> {
        let body = AppRequestModel(
            token: authenticated ? authTokens.accessToken : nil,
            data: data
        )
        return try await post(path, body: body)
    }

    /// Token-only variant — for endpoints like `/circles/list` that take
    /// no payload other than the access token.
    func send<R: Decodable>(
        _ path: String,
        authenticated: Bool = true
    ) async throws -> AppResponseModel<R> {
        let body = AppRequestModel<Empty>(
            token: authenticated ? authTokens.accessToken : nil
        )
        return try await post(path, body: body)
    }

    // MARK: - Internals

    private struct Empty: Encodable {}

    private func buildRequest<B: Encodable>(
        path: String,
        method: String,
        query: [String: String] = [:],
        body: B?
    ) throws -> URLRequest {
        var components = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        )
        if !query.isEmpty {
            components?.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = components?.url else { throw APIError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        AuthInterceptor.apply(to: &request, tokens: authTokens)

        if let body, !(body is Empty) {
            request.httpBody = try encoder.encode(body)
        }
        return request
    }

    private func perform<T: Decodable>(_ request: URLRequest) async throws -> T {
        Logger.logRequest(request)
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            Logger.logError(error, request: request)
            throw APIError.network(error)
        }
        Logger.logResponse(response, data: data)

        guard let http = response as? HTTPURLResponse else {
            let err = APIError.invalidResponse
            Logger.logError(err, request: request, response: response, data: data)
            throw err
        }

        // Backend-shaped error envelope — mirrors CustomDio._checkResponseStatus.
        // Backend uses HTTP 200/500 and signals failures through `status: "error"`
        // in the body, so we must inspect every response — not just non-2xx.
        if let backendError = parseBackendError(data) {
            if backendError.code == 1001 {
                handleSessionExpired()
            }
            let err = APIError.backend(code: backendError.code, description: backendError.description)
            Logger.logError(err, request: request, response: response, data: data)
            throw err
        }

        guard (200..<300).contains(http.statusCode) else {
            let err = APIError.fromStatus(http.statusCode, data: data)
            Logger.logError(err, request: request, response: response, data: data)
            throw err
        }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            let err = APIError.decoding(error)
            Logger.logError(err, request: request, response: response, data: data)
            throw err
        }
    }

    private func parseBackendError(_ data: Data) -> (code: Int?, description: String?)? {
        guard
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            (json["status"] as? String) == "error"
        else { return nil }
        return (json["error_code"] as? Int, json["description"] as? String)
    }

    private func handleSessionExpired() {
        authTokens.clear()
        NotificationCenter.default.post(name: .sessionExpired, object: nil)
    }
}
