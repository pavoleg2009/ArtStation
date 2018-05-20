import UIKit

class ProjectCell: UICollectionViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var iconStack: UIStackView!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var videoIcon: UIImageView!
    @IBOutlet weak var model3dIcon: UIImageView!
    @IBOutlet weak var marmosetIcon: UIImageView!
    @IBOutlet weak var panoIcon: UIImageView!
    @IBOutlet var icons: [UIImageView]!
    
    // MARK: Instance Properties
    
    private struct Consts {
        static let placeholerImage = "small_square-placehholder"
    }
    
    var projectViewModel: ProjectViewModel!
    
    // Image loading protocol
    var imageLoadingTask: URLSessionTask?
    
    // MARK: Instance Methods
    
    private func configureIcons(with options: IconsOptions) {
        imageIcon.isHidden = !options.contains(.image)
        videoIcon.isHidden = !options.contains(.video)
        model3dIcon.isHidden = !options.contains(.model3d)
        marmosetIcon.isHidden = !options.contains(.marmoset)
        panoIcon.isHidden = !options.contains(.pano)
    }
    
    func configure(with projectViewModel: ProjectViewModel, and cellSize: CellSize) {
        self.projectViewModel = projectViewModel
        
        let imageLink: URL
        switch cellSize {
        case .small: imageLink = projectViewModel.image200Link
        case .medium: imageLink = projectViewModel.image400Link
        case .large: imageLink = projectViewModel.image800Link
        }
        
        loadImage(
            from: imageLink,
            errorHandler: { //[weak self]
                error in
//                guard let sself = self else { return }
                print("!!== load image error: \(error.localizedDescription)")
        },
            successHandler: { [weak self]  image, url in
                guard let sself = self else { return }
                DispatchQueue.main.async {
                    if self?.projectViewModel.image800Link.lastPathComponent == url.lastPathComponent {
                        sself.imageView.image = image
                    } else {
                        print("!!== cell image update skipped")
                    }
                    
                }
            }
        )
        
        if cellSize != .small {
            configureIcons(with: projectViewModel.iconOptions)
        }
    }
    
    func updateImageViewWithImage(_ image: UIImage?) {
        if let image = image {
            imageView.image = image
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        } else {
            imageView.image = nil
            imageView.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        icons.forEach{ $0.isHidden = true}
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: Consts.placeholerImage)
        imageLoadingTask?.cancel()
        activityIndicator.isHidden = false
        icons.forEach{ $0.isHidden = true}
    }
}

extension ProjectCell: ImageLoading {
    
    var activityIndicatorView: UIActivityIndicatorView! {
        return self.activityIndicator
    }
    
    var targetImageView: UIImageView! {
        return self.imageView
    }
}

protocol ImageLoading: class {
    var targetImageView: UIImageView! { get }
    var activityIndicatorView: UIActivityIndicatorView! { get }
    var imageLoadingTask: URLSessionTask? { get set }
}

extension ImageLoading {
    func loadImage(from url: URL,
                   errorHandler: @escaping ErrorHandler,
                   successHandler: @escaping LoadImageSuccesHandler) {
        activityIndicatorView.startAnimating()
        imageLoadingTask = ImageLoader.loadImage(
            from: url,
            errorHandler: errorHandler,
            successHandler: successHandler
//            errorHandler: { [weak self] error in
//                guard let sself = self else { return }
//                sself.onImageLoaded(image: nil)
//        },
//            successHandler: { [weak self]  image in
//                guard let sself = self else { return }
//                sself.onImageLoaded(image: image)
//        }
        )
    }
    
//    private var placeholerImage: UIImage {
//        let placeholerImage = "small_square-placehholder"
//        return UIImage(named: placeholerImage)!
//    }
    
//    private func onImageLoaded(image: UIImage?) {
//        imageLoadingTask = nil
//        activityIndicatorView.stopAnimating()
//        guard let loadedImage = image else {
//            DispatchQueue.main.async {
//                self.targetImageView.image = self.placeholerImage
//            }
//
//            return
//        }
//        DispatchQueue.main.async {
//            self.targetImageView.image = loadedImage
//        }
//    }
}

enum ImageLoaderError: Error {
    case couldNotCreateImageFromData
}


typealias ErrorHandler = (Error) -> Void
typealias LoadImageSuccesHandler = (UIImage, URL) -> Void

struct ImageLoader {
    
    static let imageCache = NSCache<NSString, UIImage>()
    
    static func loadImage(from url: URL,
                          errorHandler: @escaping ErrorHandler,
                          successHandler: @escaping LoadImageSuccesHandler) -> URLSessionTask? {
        
//        if let cachedImage = LocalImageCache.image(for: url) {
//            successHandler(cachedImage)
//            return nil
//        }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            successHandler(cachedImage, url)
            print("💾 for \(url.lastPathComponent)")
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
            }
        )
        
    }
}

struct LocalImageCache {
    
    private static func urlInCachesDirectory(for imageURL: URL) -> URL {
        let imageName = imageURL.path.replacingOccurrences(of: "/", with: "-")
        guard let cacheDirectory = FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first else { fatalError("Could not access caches directory") }
        
        return cacheDirectory.appendingPathComponent(imageName)
    }
    
    static func image(for url: URL) -> UIImage? {
        let storeUrl = urlInCachesDirectory(for: url)
        guard let imageData = try? Data(contentsOf: storeUrl) else { return nil }
        return UIImage(data: imageData)
    }
    
    static func write(_ image: UIImage, for url: URL) {
        let storeUrl = urlInCachesDirectory(for: url)
        
        guard let imageData = UIImagePNGRepresentation(image) else {
            assertionFailure("Could not get Data for image!")
            return
        }
        
        do {
            try imageData.write(to: storeUrl)
        } catch {
            print("=== Could not write data for \(url) to \(storeUrl): \(error)")
        }
    }
}

typealias LoadDataSuccesHandler = (Data) -> Void

enum NetworkError: Error {
    case
    dataCouldNotBeLoaded,
    noErrorAndNoData,
    noHost,
    noLocalDataForThisHost
    
}

struct NetworkDataFetcher {
    static func fetchData(
        from url: URL,
        errorHandler: @escaping ErrorHandler,
        successHandler: @escaping LoadDataSuccesHandler) -> URLSessionTask? {
        print("📡 for \(url.lastPathComponent)")
        let task = URLSession.shared.dataTask(with: url) {
            data, urlResponse, error in
            
//            DispatchQueue.main.async {
                if let networkError = error {
                    errorHandler(networkError)
                    return
                }
                
                if let fetchedData = data {
                    successHandler(fetchedData)
                    return
                }
                errorHandler(NetworkError.noErrorAndNoData)
//            }
        }
        
        task.resume()
        return task
    }
}
