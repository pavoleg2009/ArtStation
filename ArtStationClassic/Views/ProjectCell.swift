//
//  ProjectCell.swift
//  ArtStationClassic
//
//  Created by Oleg Pavlichenkov on 18/05/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

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
    
    func configure(with projectViewModel: ProjectViewModel, showAdditionaInfo: Bool) {
        self.projectViewModel = projectViewModel
        
        loadImage(from: projectViewModel.imageLink)
        
        if showAdditionaInfo {
            configureIcons(with: projectViewModel.iconOptions)
        }
    }
    
    func updateImageViewWithImage(_ image: UIImage?) {
        if let image = image {
            imageView.image = image
            
//            imageView.alpha = 0
//            UIView.animate(withDuration: 0.3, animations: {
//                self.imageView.alpha = 1.0
//                self.activityIndicator.alpha = 0
//            }, completion: {
//                _ in
//                self.activityIndicator.stopAnimating()
//            })
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        } else {
            imageView.image = nil
//            imageView.alpha = 0
//            activityIndicator.alpha = 1.0
            imageView.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
    }
    
    override func awakeFromNib() {
        icons.forEach{ $0.isHidden = true}
    }
    
    override func prepareForReuse() {
        imageView.image = UIImage(named: Consts.placeholerImage)
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
    func loadImage(from url: URL) {
        activityIndicatorView.startAnimating()
        imageLoadingTask = ImageLoader.loadImage(
            from: url,
            errorHandler: { [weak self] error in
                guard let sself = self else { return }
                sself.onImageLoaded(image: nil)
        },
            successHandler: { [weak self]  image in
                guard let sself = self else { return }
                sself.onImageLoaded(image: image)
        })
    }
    
    private var placeholerImage: UIImage {
        let placeholerImage = "small_square-placehholder"
        return UIImage(named: placeholerImage)!
    }
    
    private func onImageLoaded(image: UIImage?) {
        imageLoadingTask = nil
        activityIndicatorView.stopAnimating()
        guard let loadedImage = image else {
            targetImageView.image = self.placeholerImage
            return
        }
        targetImageView.image = loadedImage
    }
}

enum ImageLoaderError: Error {
    case couldNotCreateImageFromData
}


typealias ErrorHandler = (Error) -> Void
typealias LoadImageSuccesHandler = (UIImage) -> Void

struct ImageLoader {
    static func loadImage(from url: URL,
                          errorHandler: @escaping ErrorHandler,
                          successHandler: @escaping LoadImageSuccesHandler) -> URLSessionTask? {
        
        if let cachedImage = LocalImageCache.image(for: url) {
            successHandler(cachedImage)
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
                successHandler(image)
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
        
        let task = URLSession.shared.dataTask(with: url) {
            data, urlResponse, error in
            
            DispatchQueue.main.async {
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
        }
        
        task.resume()
        return task
    }
}
