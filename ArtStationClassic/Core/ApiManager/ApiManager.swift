import Foundation

typealias SuccessCallback<ResponseType> = (_ response: ResponseType?, _ task: URLSessionTask?) -> Void
typealias FailureCallback<ErrorType> = (_ error: ErrorType, _ task: URLSessionTask?) -> Void

protocol ApiManager {
    func makeRequest<T: Request>(request: T,
                           onSuccess: @escaping SuccessCallback<T.ResponseType>,
                           onFailure: @escaping FailureCallback<ApiError>) -> URLSessionTask?
}
