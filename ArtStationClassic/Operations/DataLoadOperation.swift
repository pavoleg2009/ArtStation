import Foundation

typealias LoadOperationComletion = (Data?, Error?) -> ()

final class DataLoadOperation: AsyncOperation {
    private let url: URL
    private var session: URLSessionProtocol
    private let completion: LoadOperationComletion?
    private var loadedData: Data?
    private var error: Error?
    
    init(url: URL,
         session: URLSessionProtocol = URLSession.shared,
         completion: LoadOperationComletion? = nil) {
        self.url = url
        self.session = session
        self.completion = completion
        super.init()
    }
    
    override func main() {
        guard !self.isCancelled else { return }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard !self.isCancelled else { return }
            
            self.error = error
            self.loadedData = data
            self.completion?(data, error)
            self.state = .finished
        }
        task.resume()
    }
}

extension DataLoadOperation: ImageDecompressionDataProvider {
    var compressedData: Data? {
        return loadedData
    }  
}
