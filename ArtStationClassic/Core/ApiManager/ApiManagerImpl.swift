import Foundation

final class ApiManagerImpl: ApiManager {
    
    // MARK: Dependencies
    let session: URLSessionProtocol
    let parser: Parser
    
    // MARK: Initializers
    init(session: URLSessionProtocol = URLSession(configuration: .default),
         parser: Parser = JSONParser()) {
        self.session = session
        self.parser = parser
    }
    
    // MARK: Instance Methods
    @discardableResult
    func makeRequest<T: Request>(request: T,
                                 onSuccess: @escaping SuccessCallback<T.ResponseType>,
                                 onFailure: @escaping FailureCallback<ApiError>) -> URLSessionDataTask? {
        
        let urlRequest: URLRequest
        do {
            urlRequest = try request.urlRequest()
            //            print("\n=== urlRequest.url = \(urlRequest.url)\n")
        } catch {
            onFailure(ApiError.badRequest, nil)
            return nil
        }
        
        let task = self.session.dataTask(with: urlRequest) { [weak self] data, response, error in
            
            guard let sself = self else  { return }
            
            if let error = error {
                print("==== Error: \(error.localizedDescription)")
                onFailure(ApiError.badRequest, nil)
            } else if let data = data {
                
                do {
                    let result: T.ResponseType = try sself.parser.parse(data: data)
                    onSuccess(result, nil)
                } catch {
                    
                    // TODO: Add cutom parsing error
                    print("==== Parse Error: \(error.localizedDescription)")
                }
                
            } else {
                onFailure(ApiError.noData, nil)
            }
        }
        task.resume()
        return task
    }    
}
