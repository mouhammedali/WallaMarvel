import XCTest
@testable import WallaMarvel

final class SuperheroEndpointTests: XCTestCase {

    func test_allHeroesEndpoint_hasCorrectPath() throws {
        let endpoint = SuperheroEndpoint.allHeroes
        let request = try endpoint.asURLRequest()

        XCTAssertTrue(request.url?.absoluteString.contains("/all.json") ?? false)
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func test_heroEndpoint_includesId() throws {
        let endpoint = SuperheroEndpoint.hero(id: 42)
        let request = try endpoint.asURLRequest()

        XCTAssertTrue(request.url?.absoluteString.contains("/id/42.json") ?? false)
    }

    func test_allHeroesEndpoint_hasNoQueryItems() throws {
        let endpoint = SuperheroEndpoint.allHeroes
        let request = try endpoint.asURLRequest()
        let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)

        XCTAssertTrue(components?.queryItems?.isEmpty ?? true)
    }

    func test_endpoint_usesCorrectBaseURL() throws {
        let endpoint = SuperheroEndpoint.allHeroes
        let request = try endpoint.asURLRequest()

        XCTAssertTrue(request.url?.absoluteString.hasPrefix("https://akabab.github.io/superhero-api/api") ?? false)
    }
}
