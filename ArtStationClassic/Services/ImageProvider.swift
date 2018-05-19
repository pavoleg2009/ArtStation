import UIKit

protocol ImageProvider {
    
    init(url: URL, completion: @escaping (UIImage?) -> ())
}

final class ImageProviderImpl: ImageProvider {
    
    private let operationQueue = OperationQueue()
    
    let url: URL
    
    init(url: URL, completion: @escaping (UIImage?) -> ()) {
        self.url = url

        let loadData = DataLoadOperation(url: url)
        let imageDecompression = ImageDecompressionOperation(data: nil)
        let imageOutput = ImageOutputOperation(completion: completion)
        
        let operations = [loadData, imageDecompression, imageOutput]
        
        imageDecompression.addDependency(loadData)
        imageOutput.addDependency(imageDecompression)
        
        operationQueue.addOperations(operations, waitUntilFinished: false)
    }
    
    func cancel() {
        operationQueue.cancelAllOperations()
    }
}

extension ImageProviderImpl: Hashable {
    var hashValue: Int {
        return url.hashValue
    }
    
    static func == (lhs: ImageProviderImpl, rhs: ImageProviderImpl) -> Bool {
        return lhs.url == rhs.url
    }
    
    
}
