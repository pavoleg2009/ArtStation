import UIKit

typealias LoadImageErrorHandler = (Error) -> Void
typealias LoadImageSuccesHandler = (UIImage, URL) -> Void

struct ImageLoader {
    
    static let imageCache = NSCache<NSString, UIImage>()
    
    static func loadImage(from url: URL,
                          errorHandler: @escaping LoadImageErrorHandler,
                          successHandler: @escaping LoadImageSuccesHandler) -> URLSessionTask? {
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            successHandler(cachedImage, url)
            return nil
        }
        
        return NetworkDataFetcher.fetchData(
            from: url,
            errorHandler: errorHandler,
            successHandler: { data in
                guard let image = UIImage(data: data) else {
                    errorHandler(ImageLoaderError.couldNotCreateImageFromData)
                    return
                }
                LocalImageCache.write(image, for: url)
                successHandler(image, url)
                imageCache.setObject(image, forKey: url.absoluteString as NSString)
        })
    }
}
