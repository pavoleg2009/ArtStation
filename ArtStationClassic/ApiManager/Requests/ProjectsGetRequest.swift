import Foundation

// Struct for holding request param and providing appropriate URL for request
// https://www.artstation.com/projects.json?page=1&sorting=trending

final class ProjectsGetRequest: Request {
    
    typealias ResponseType = ProjectsRequestResponse
    
    private struct Keys {
        static let page = "page"
        static let sorting = "sorting"
    }
    
    // MARK: - Type Properties
    
    private static let defaultSorting = "trending"
    
    // MARK: - Instance Properties
    
    let path: String = "projects.json"
    private let page: Int
    
    // MARK: - Initializers
    
    init(page: Int = 1) {
        self.page = page
    }
    
    // MARK: - Instance Methods
    
    func urlRequest() throws -> URLRequest {
        if let url = urlForRequest(page: page) {
            return URLRequest(url: url)
        } else {
            throw ApiError.badRequest
        }
    }
    
    // MARK: - Private
    
    private func urlForRequest(page: Int) -> URL? {
        
        let methodUrl = baseURL.appendingPathComponent(path)
        var urlComponents = URLComponents(url: methodUrl, resolvingAgainstBaseURL: false)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: Keys.page, value: "\(self.page)"),
            URLQueryItem(name: Keys.sorting, value: "\(ProjectsGetRequest.defaultSorting)"),
        ]

        return urlComponents.url
    }
    
}

