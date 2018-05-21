import UIKit

protocol ImageLoading: class {
    var targetImageView: UIImageView! { get }
    var activityIndicatorView: UIActivityIndicatorView! { get }
    var imageLoadingTask: URLSessionTask? { get set }
}

extension ImageLoading {
    func loadImage(from url: URL,
                   errorHandler: @escaping LoadImageErrorHandler,
                   successHandler: @escaping LoadImageSuccesHandler) {
        activityIndicatorView.startAnimating()
        imageLoadingTask = ImageLoader.loadImage(
            from: url,
            errorHandler: errorHandler,
            successHandler: successHandler
        )
    }
}
