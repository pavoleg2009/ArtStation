import UIKit

protocol ImageDecompressionDataProvider {
    var compressedData: Data? { get }
}

typealias ImageDecompressionCompletion = (UIImage?) -> ()

final class ImageDecompressionOperation: Operation {
    private let inputData: Data?
    private let completion: ImageDecompressionCompletion?
    private var outputImage: UIImage?
    
    init(data: Data?, competion: ImageDecompressionCompletion? = nil) {
        self.inputData = data
        self.completion = competion
        super.init()
    }
    
    override func main() {
        let data: Data?
        guard !self.isCancelled else { return }
        
        if let inputData = inputData {
            data = inputData
        } else {
            let dataProvider = dependencies
                .filter { $0 is ImageDecompressionDataProvider}
                .first as? ImageDecompressionDataProvider
            data = dataProvider?.compressedData
        }
        
        guard let imageData = data else { return }
        guard !self.isCancelled else { return }
        outputImage = UIImage(data: imageData)
    }
}

extension ImageDecompressionOperation: ImageProcessingDataProvider {
    var image: UIImage? {
        return outputImage
    }
}
