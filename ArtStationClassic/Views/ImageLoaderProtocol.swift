import UIKit

protocol ImageLoaderProtocol: class {
    var targetImageView: UIImageView! { get }
    var activityIndicatorView: UIActivityIndicatorView! { get }
    var imageLoadingTask: URLSessionTask! { get set }
    
    func loadImage(from url: URL)
}

extension ImageLoaderProtocol {
    func loadImage(from url: URL) {
        activityIndicatorView.startAnimating()
    }
}
