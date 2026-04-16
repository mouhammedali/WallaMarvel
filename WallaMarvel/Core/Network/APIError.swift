import Foundation

enum APIError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingFailed(Error)
    case noData
    case networkError(Error)

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.invalidResponse, .invalidResponse),
             (.noData, .noData):
            return true
        case (.httpError(let lhsCode), .httpError(let rhsCode)):
            return lhsCode == rhsCode
        case (.decodingFailed, .decodingFailed),
             (.networkError, .networkError):
            return false
        default:
            return false
        }
    }

    var userMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid request configuration."
        case .invalidResponse:
            return "Received an unexpected response from the server."
        case .httpError(let statusCode):
            return "Server error (code: \(statusCode)). Please try again later."
        case .decodingFailed:
            return "Failed to process server response."
        case .noData:
            return "No data available."
        case .networkError:
            return "Network connection failed. Please check your internet connection."
        }
    }
}
