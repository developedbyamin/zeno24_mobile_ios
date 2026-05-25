import Foundation

final class CirclesRepository {
    private let service: CirclesService

    init(service: CirclesService) {
        self.service = service
    }

    func list() async throws -> [CircleModel] {
        let response = try await service.list()
        return response.data ?? []
    }

    func add(name: String, avatarUrl: String? = nil) async throws -> CircleModel {
        let response = try await service.add(.init(title: name, avatarUrl: avatarUrl))
        guard let id = response.data?.id else { throw APIError.invalidResponse }
        return CircleModel(
            id: id,
            name: name,
            memberCount: 1,
            isCurrent: false,
            avatarUrl: avatarUrl,
            isOwner: true
        )
    }

    func info(circleId: String) async throws -> InfoCircleResponseModel {
        let response = try await service.info(.init(circleId: circleId))
        guard let data = response.data else { throw APIError.invalidResponse }
        return data
    }

    func join(code: String) async throws -> CircleModel {
        let response = try await service.join(.init(code: code))
        guard let data = response.data else { throw APIError.invalidResponse }
        return data
    }

    func invite(circleId: String, role: String? = nil) async throws -> InviteCircleResponseModel {
        let response = try await service.invite(.init(circleId: circleId, role: role))
        guard let data = response.data else { throw APIError.invalidResponse }
        return data
    }

    func switchTo(circleId: String) async throws {
        try await service.switchTo(.init(circleId: circleId))
    }
}
