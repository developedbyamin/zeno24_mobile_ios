import Foundation

final class MarkersService {
    private enum Const {
        static let endpoint = URL(string: "https://api.navimax.net/api/navimax/panelobjects/synclist")!
        static let appId = 608
        static let token = "1-e0Hc4d4dxdg0M0B1h0z0JcS0We64OfP0Q0cedH1W692gaJ1L0lg8Yax6G0x0k0g3X8O6_043dda907f981c00ec0afd26160ce30804d6301e"
    }

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        let dec = JSONDecoder()
        dec.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = dec
    }

    func fetchSyncList() async throws -> PanelSyncResponseModel {
        var request = URLRequest(url: Const.endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let body: [String: Any] = [
            "app_id": Const.appId,
            "token": Const.token,
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        Logger.logRequest(request)
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            Logger.logError(error, request: request)
            throw APIError.network(error)
        }
        Logger.logResponse(response, data: data)

        do {
            return try decoder.decode(PanelSyncResponseModel.self, from: data)
        } catch {
            Logger.logError(error, request: request, response: response, data: data)
            throw APIError.decoding(error)
        }
    }
}
