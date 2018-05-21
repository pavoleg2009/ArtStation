import Foundation
@testable import ArtStationClassic

final class ApiManagerMock_SuccessProjectsResult: ApiManager {

    func makeRequest<T>(request: T, onSuccess: @escaping (T.ResponseType?, URLSessionTask?) -> Void, onFailure: @escaping (ApiError, URLSessionTask?) -> Void) -> URLSessionDataTask? where T : Request {
        
        let jsonUrl = Bundle(for: type(of:self))
            .url(forResource: "projectsResponse", withExtension: "json")!
        
        let data = try! Data(contentsOf: jsonUrl)
        let result: T.ResponseType = try! JSONParser().parse(data: data)
        
        onSuccess(result, nil)
        
        return nil
    }
    
    
}
