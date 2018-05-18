import Foundation

protocol Request {
    associatedtype ResponseType: Response
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String] { get }
    var baseURL: URL { get }
    func urlRequest() throws -> URLRequest
}

enum HTTPMethod: String {
    case get = "GET"
}

extension Request {
    
    var method: HTTPMethod {
        return .get
    }
    
    var baseURL: URL {
        return URL(string: "https://www.artstation.com")!
    }
    
    var headers: [String : String] {
        return [:]// ["Content-Type" : "application/json"]
    }
}
