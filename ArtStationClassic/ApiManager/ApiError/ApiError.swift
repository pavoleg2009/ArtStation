import Foundation

enum ApiError: Error {
    case badRequest
    case networkError
    case authError
    case parseError
    case noData
}
