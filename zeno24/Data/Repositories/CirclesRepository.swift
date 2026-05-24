import Foundation

/// Circles repository — mirrors circles_repository.dart
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
        let response = try await service.add(.init(name: name, avatarUrl: avatarUrl))
        guard let circle = response.data?.circle else { throw APIError.invalidResponse }
        return circle
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

    func invite(circleId: String, phone: String) async throws -> InviteCircleResponseModel {
        let response = try await service.invite(.init(circleId: circleId, phone: phone))
        guard let data = response.data else { throw APIError.invalidResponse }
        return data
    }

    func switchTo(circleId: String) async throws {
        try await service.switchTo(.init(circleId: circleId))
    }
}
