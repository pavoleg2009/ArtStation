import UIKit

final class ProjectsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var zoomInButton: UIBarButtonItem!
    
    // MARK:
    
    private struct Consts {
        static let cellReuseIdenrtifier = "ProjectCell"
        static let detailSegueIdentifier = "ShowProjectDetails"
        static let maxColumns: CGFloat = 3.0
        static let inset: CGFloat = 8.0
        static let cellsSpacing: CGFloat = 4.0
    }
    
    var columns: CGFloat = 3.0 {
        didSet {
            configure(collectionView,
                      forCellsInRow: columns,
                      withSpacing: Consts.cellsSpacing)
        }
    }
    
    private let projectService: ProjectService = ProjectServiceImpl()
    private var projectViewModels: [ProjectViewModel] = []
    private var nextPage = 1
    private var fetchingPages: Set<Int> = []
    private var selectedProjectViewModel: ProjectViewModel?
    private var activeTask: URLSessionTask?
    
    private var imageProviders: Set<ImageProviderImpl> = []
    
    // MARK: - Actions
    @IBAction func zoomIn(_ sender: UIBarButtonItem) {
        columns = (columns == 1.0)
            ? Consts.maxColumns
            : columns - 1
    }
    
    @objc private func refreshControlDidFire() {
        refresh()
        collectionView.refreshControl?.endRefreshing()
    }
    
    // MARK: Instance Methods

    private func configure(_ collectionView: UICollectionView,
                           forCellsInRow cellsInRow: CGFloat,
                           withSpacing spacing: CGFloat) {
        
        let spaceForMagrins = (cellsInRow - 1.0) * spacing
        let cellWidth = floor((collectionView.bounds.size.width - spaceForMagrins) / cellsInRow)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
    }
    
    private func refresh() {
        fetchingPages = []
        nextPage = 1
        fetchProjects()
    }
    
    private func fetchProjects() {
        beginUpdates()
        fetchingPages.insert(nextPage)
        print("fethc page: \(nextPage)")
        activeTask = projectService.fetchProjects(page: nextPage) {
            [weak self] (fetchedProjectViewModels) in
            
            guard let sself = self else { return }
            
            if let fetchedProjectViewModels = fetchedProjectViewModels {
                if sself.nextPage == 1 {
                    sself.projectViewModels = fetchedProjectViewModels
                } else {
                    sself.projectViewModels.append(contentsOf: fetchedProjectViewModels)
                }
                sself.nextPage += 1
            } else {
                // show error message
            }
            DispatchQueue.main.async {
                sself.endUpdates()
            }
        }
    }
    
    private func fetchNextPage() {
        if !fetchingPages.contains(nextPage) {
            fetchProjects()
        }
    }
    
    private func beginUpdates() {
        collectionView.refreshControl?.beginRefreshing()
    }
    
    private func endUpdates() {
        // hide spinner, unblock UI
        activeTask = nil
        collectionView.reloadData()
        collectionView.refreshControl?.endRefreshing()
    }
    
    private func setNavigaionItemTitle(with image: UIImage?) {
        let imageView: UIImageView!
        if #available(iOS 11, *) {
            imageView = UIImageView()
            imageView.heightAnchor.constraint(equalToConstant: 27).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 174).isActive = true
        } else {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 174, height: 27))
        }
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        navigationItem.titleView = imageView
    }

    private func setupNavbar() {
        setNavigaionItemTitle(with: UIImage(named: "LogoHorisontal"))
        navigationController?.navigationBar.tintColor = AppColor.brandPrimary
    }
    
    private func setRefreshControl(for collectionView: UICollectionView, with selector: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: selector, for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
}

// MARK: Overrides
extension ProjectsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setRefreshControl(for: collectionView, with: #selector(refreshControlDidFire))
        refresh()
    }
    
    override func viewWillLayoutSubviews() {
        configure(collectionView,
                  forCellsInRow: columns,
                  withSpacing: Consts.cellsSpacing)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Consts.detailSegueIdentifier {
            guard let viewController = segue.destination as? ProjectDetailsViewController
                else { fatalError("==== Wrong viewController class") }
            
            guard let selectedProjectViewModel = selectedProjectViewModel else { return }
            viewController.detailLink = selectedProjectViewModel.detailLink
            viewController.projectViewModel = selectedProjectViewModel
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalIndicator = scrollView.subviews.last as? UIImageView
        verticalIndicator?.backgroundColor = AppColor.brandPrimary
    }
}

// MARK: UICollectionViewDataSource
extension ProjectsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Consts.cellReuseIdenrtifier, for: indexPath) as? ProjectCell else { fatalError("==== Wrong cell type")}
        
        let prefetchThreshhold = Int(columns) * 5
        print("Count: \(projectViewModels.count) Item: \(indexPath.item) prefetchThreshhold \(prefetchThreshhold)")
        if (projectViewModels.count - indexPath.item) < prefetchThreshhold {
            fetchNextPage()
        }
        
        let projectViewModel = projectViewModels[indexPath.item]
        
        let minColCountToShowIcons: CGFloat = 2.0
        cell.configure(with: projectViewModel, showAdditionaInfo: columns <= minColCountToShowIcons)
        
//        let imageProvider = ImageProviderImpl(url: projectViewModel.imageLink) {
//            image in
//            OperationQueue.main.addOperation {
//                cell.updateImageViewWithImage(image)
//            }
//        }
//        imageProviders.insert(imageProvider)
        
        return cell
    }
    
}

// MARK: UICollectionViewDelegate
extension ProjectsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // show
//        guard let selectedCell = collectionView.cellForItem(at: indexPath) else { return }
        selectedProjectViewModel = projectViewModels[indexPath.item]
        performSegue(withIdentifier: Consts.detailSegueIdentifier, sender: nil)
    }

//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard let cell = cell as? ProjectCell else { return }
//
//
//    }
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard let cell = cell as? ProjectCell else { return }
//
//        for provider in imageProviders.filter({ $0.url == cell.projectViewModel.imageLink }) {
//            provider.cancel()
//            imageProviders.remove(provider)
//            print("=== remove provider for: \(provider.url.lastPathComponent)")
//        }
//    }
}
