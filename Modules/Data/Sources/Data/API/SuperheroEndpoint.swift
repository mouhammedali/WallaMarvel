import Foundation
import Networking

public enum SuperheroEndpoint: Endpoint {
    case allHeroes
    case hero(id: Int)

    public var baseURL: String { "https://akabab.github.io/superhero-api/api" }

    public var path: String {
        switch self {
        case .allHeroes:
            return "/all.json"
        case .hero(let id):
            return "/id/\(id).json"
        }
    }

    public var method: HTTPMethod { .get }

    public var queryItems: [URLQueryItem] { [] }
}
