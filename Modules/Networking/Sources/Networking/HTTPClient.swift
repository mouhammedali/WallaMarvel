import Foundation

public protocol HTTPClient: Sendable {
    func request<T: Decodable>(_ endpoint: any Endpoint) async throws -> T
}

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    private let decoder: JSONDecoder

    /// Uses a hardened session configuration rather than URLSession.shared.
    /// - Enforces TLS 1.2+ to prevent downgrade attacks
    /// - Disables URL caching to avoid storing sensitive responses on disk
    /// - Configurable timeouts per session (30s request, 60s resource)
    public init(
        session: URLSession = URLSessionHTTPClient.makeSecureSession(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }

    public func request<T: Decodable>(_ endpoint: any Endpoint) async throws -> T {
        let urlRequest = try endpoint.asURLRequest()

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw APIError.networkError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }

    // MARK: - Session Configuration

    public static func makeSecureSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.tlsMinimumSupportedProtocolVersion = .TLSv12
        config.urlCache = nil
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        config.httpAdditionalHeaders = ["Accept": "application/json"]
        return URLSession(configuration: config)
    }
}
