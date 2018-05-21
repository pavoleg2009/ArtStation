import Foundation

typealias LoadDataErrorHandler = (Error) -> Void
typealias LoadDataSuccesHandler = (Data) -> Void

enum NetworkError: Error {
    case
    dataCouldNotBeLoaded,
    noErrorAndNoData,
    noHost,
    noLocalDataForThisHost
}

struct NetworkDataFetcher {
    static func fetchData(from url: URL,
                          errorHandler: @escaping LoadDataErrorHandler,
                          successHandler: @escaping LoadDataSuccesHandler) -> URLSessionTask? {
        
        let task = URLSession.shared.dataTask(with: url) {
            data, urlResponse, error in
            
            if let networkError = error {
                errorHandler(networkError)
                return
            }
            if let fetchedData = data {
                successHandler(fetchedData)
                return
            }
            errorHandler(NetworkError.noErrorAndNoData)
        }
        
        task.resume()
        return task
    }
}
