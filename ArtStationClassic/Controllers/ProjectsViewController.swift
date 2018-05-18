import UIKit

final class ProjectsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK:
    
    private struct Consts {
        static let cellReuseIdenrtifier = "ProjectCell"
        static let detailSegueIdentifier = "ShowProjectDetails"
        static let cellsInRow: CGFloat = 3.0
        static let cellsSpacing: CGFloat = 4.0
    }
    
    let projectService: ProjectService = ProjectServiceImpl()
    var projectViewModels: [ProjectViewModel] = []
    var nextPage = 1
    var pagesInPrefetching: Set<Int> = []
    var selectedProjectViewModel: ProjectViewModel?
    
    private func beginUpdates() {
        // show spinner, block UI
    }
    
    private func endUpdates() {
        // hide spinner, unblock UI
        collectionView.reloadData()
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
        projectService.fetchProjects(page: nextPage) {
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
}

// MARK: View Lifecycle
extension ProjectsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        cell.label.text = "Row: \(indexPath.item) Id: \(projectViewModel.id)"
        
        
        return cell
    }
    
    override func viewWillLayoutSubviews() {
        configure(collectionView,
                  forCellsInRow: Consts.cellsInRow,
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
}
