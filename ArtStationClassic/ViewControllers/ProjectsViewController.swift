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
//            collectionView.reloadData()
            print(columns)
        }
    }
    
    private let projectService: ProjectService = ProjectServiceImpl()
    private var projectViewModels: [ProjectViewModel] = []
    private var nextPage = 1
//    private var pagesInPrefetching: Set<Int> = []
    private var selectedProjectViewModel: ProjectViewModel?
    private var activeTask: URLSessionTask?
    
    private var imageProviders: Set<ImageProviderImpl> = []
    
    private func beginUpdates() {
        collectionView.refreshControl?.beginRefreshing()
    }
    
    private func endUpdates() {
        // hide spinner, unblock UI
        activeTask = nil
        collectionView.reloadData()
        collectionView.refreshControl?.endRefreshing()
    }
    
    private func setRefreshControl(for collectionView: UICollectionView, with selector: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: selector, for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func refreshControlDidFire() {
        print("== refresh controle fired")
        collectionView.reloadData()
        collectionView.refreshControl?.endRefreshing()
    }
    
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
    
    private func fetchProjects() {
        beginUpdates()
        activeTask = projectService.fetchProjects(page: nextPage) {
            [weak self] (fetchedProjectViewModels) in
            
            guard let sself = self else { return }
            
            if let fetchedProjectViewModels = fetchedProjectViewModels {
                sself.projectViewModels = fetchedProjectViewModels
                
            } else {
                // show error message
            }
            DispatchQueue.main.async {
                sself.endUpdates()
            }
        }
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
    
    @IBAction func zoomIn(_ sender: UIBarButtonItem) {
        columns = (columns == 1.0)
            ? Consts.maxColumns
            : columns - 1
    }

    private func setupNavbar() {
        setNavigaionItemTitle(with: UIImage(named: "LogoHorisontal"))
        navigationController?.navigationBar.tintColor = AppColor.brandPrimary
    }
}

// MARK: View Lifecycle
extension ProjectsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setRefreshControl(for: collectionView, with: #selector(refreshControlDidFire))
        fetchProjects()
    }
    
}

// MARK: UICollectionViewDataSource
extension ProjectsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Consts.cellReuseIdenrtifier, for: indexPath) as? ProjectCell else { fatalError("==== Wrong cell type")}
        let projectViewModel = projectViewModels[indexPath.item]
        cell.configure(with: projectViewModel)
        
        return cell
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
        }
        
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

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ProjectCell else { return }
        let projectViewModel = projectViewModels[indexPath.item]
        cell.configure(with: projectViewModel)
        
        let imageProvider = ImageProviderImpl(url: projectViewModel.imageLink) {
            image in
            OperationQueue.main.addOperation {
                cell.updateImageViewWithImage(image)
            }
        }
        imageProviders.insert(imageProvider)
        
    }
}
