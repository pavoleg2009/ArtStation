import Foundation

final class ApiManagerImpl: ApiManager {
    
    // MARK: - Dependencies
    
    let session: URLSessionProtocol
    let parser: Parser
    
    // MARK: - Initializers
    
    init(session: URLSessionProtocol = URLSession(configuration: .default),
         parser: Parser = JSONParser()) {
        self.session = session
        self.parser = parser
    }
    
    // MARK: - Instance Methods
    
    @discardableResult
    func makeRequest<T: Request>(request: T,
                                 onSuccess: @escaping SuccessCallback<T.ResponseType>,
                                 onFailure: @escaping FailureCallback<ApiError>) -> URLSessionDataTask? {
        
        let urlRequest: URLRequest
        do {
            urlRequest = try request.urlRequest()
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
                    sself.handleParseError(error)

                }
                
            } else {
                onFailure(ApiError.noData, nil)
            }
        }
        task.resume()
        return task
    }
    
     // MARK: -
    
    private func handleParseError(_ error: Error) {
        switch error {
        case DecodingError.dataCorrupted(let context):
            print("==== 🚫 Data coccupted. Description: \(context)")
        case DecodingError.keyNotFound(let key, let context):
            print("==== 🚫 Missing key: \(key)")
            print("==== 🚫 Debug Description: \(context)")
        case DecodingError.valueNotFound(let type, let context):
            print("==== 🚫 Value of type: \(type) not found")
            print("==== 🚫 Debug Description: \(context)")
        case DecodingError.typeMismatch(let type, let context):
            print("==== 🚫 Type mismathc for type: \(type)")
            print("==== 🚫 Debug Description: \(context)")
        default:
            print("==== 🚫 \(error.localizedDescription)")
        }
    }
}
