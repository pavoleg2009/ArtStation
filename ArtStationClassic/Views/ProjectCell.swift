import UIKit

final class ProjectCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var iconStack: UIStackView!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var videoIcon: UIImageView!
    @IBOutlet weak var model3dIcon: UIImageView!
    @IBOutlet weak var marmosetIcon: UIImageView!
    @IBOutlet weak var panoIcon: UIImageView!
    @IBOutlet var icons: [UIImageView]!
    
    // MARK: - Instance Properties
    
    var projectViewModel: ProjectViewModel!
    var imageLoadingTask: URLSessionTask?
    
    // MARK: - Instance Methods
    
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
            errorHandler: {
                error in
                print("==== load image error: \(error.localizedDescription)")
        },
            successHandler: { [weak self]  image, url in
                guard let sself = self else { return }
                
                if self?.projectViewModel.image800Link.lastPathComponent == url.lastPathComponent {
                    DispatchQueue.main.async {
                        sself.imageView.image = image
                    }
                }
            }
        )
        if cellSize != .small {
            configureIcons(with: projectViewModel.iconOptions)
        }
    }
    
    // MARK: -
    
    private func configureIcons(with options: IconsOptions) {
        imageIcon.isHidden = !options.contains(.image)
        videoIcon.isHidden = !options.contains(.video)
        model3dIcon.isHidden = !options.contains(.model3d)
        marmosetIcon.isHidden = !options.contains(.marmoset)
        panoIcon.isHidden = !options.contains(.pano)
    }
}

// MARK: - Overrides

extension ProjectCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        icons.forEach{ $0.isHidden = true}
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = #imageLiteral(resourceName: "small_square-placehholder")
        imageLoadingTask?.cancel()
        activityIndicator.isHidden = false
        icons.forEach{ $0.isHidden = true}
    }
}

// MARK: - ImageLoading

extension ProjectCell: ImageLoading {
    
    var activityIndicatorView: UIActivityIndicatorView! {
        return self.activityIndicator
    }
    
    var targetImageView: UIImageView! {
        return self.imageView
    }
}
