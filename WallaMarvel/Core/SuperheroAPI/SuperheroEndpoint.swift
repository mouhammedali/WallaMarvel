import Foundation

enum SuperheroEndpoint: Endpoint {
    case allHeroes
    case hero(id: Int)

    var baseURL: String { "https://akabab.github.io/superhero-api/api" }

    var path: String {
        switch self {
        case .allHeroes:
            return "/all.json"
        case .hero(let id):
            return "/id/\(id).json"
        }
    }

    var method: HTTPMethod { .get }

    var queryItems: [URLQueryItem] { [] }
}
