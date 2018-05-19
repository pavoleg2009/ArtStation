import UIKit

protocol ImageProcessingDataProvider {
    var image: UIImage? { get }
}

class ImageProcessingOperation: Operation {
    var outputImage: UIImage?
    private let _inputImage: UIImage?
    
    init(image: UIImage?) {
        _inputImage = image
        super.init()
    }
    
    var inputImage: UIImage? {
        var image: UIImage?
        if let inputImage = _inputImage {
            image = inputImage
        } else if let dataProvider = dependencies
            .filter({ $0 is ImageProcessingDataProvider })
            .first as? ImageProcessingDataProvider {
            image = dataProvider.image
        }
        return image
    }
}

extension ImageProcessingOperation: ImageProcessingDataProvider {
    var image: UIImage? {
        return outputImage
    }
}
