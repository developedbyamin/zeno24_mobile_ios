import Foundation

final class CirclesService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func list() async throws -> AppResponseModel<[CircleModel]> {
        try await client.send(APIPaths.Circles.list, authenticated: true)
    }

    func add(_ request: AddCircleRequestModel) async throws -> AppResponseModel<AddCircleResponseModel> {
        try await client.send(APIPaths.Circles.add, data: request, authenticated: true)
    }

    func info(_ request: InfoCircleRequestModel) async throws -> AppResponseModel<InfoCircleResponseModel> {
        try await client.send(APIPaths.Circles.info, data: request, authenticated: true)
    }

    func join(_ request: JoinCircleRequestModel) async throws -> AppResponseModel<CircleModel> {
        try await client.send(APIPaths.Circles.join, data: request, authenticated: true)
    }

    func invite(_ request: InviteCircleRequestModel) async throws -> AppResponseModel<InviteCircleResponseModel> {
        try await client.send(APIPaths.Circles.invite, data: request, authenticated: true)
    }

    func switchTo(_ request: SwitchCircleRequestModel) async throws {
        struct Empty: Decodable {}
        let _: AppResponseModel<Empty>? = try? await client.send(
            APIPaths.Circles.switchCircle,
            data: request,
            authenticated: true
        )
    }
}
