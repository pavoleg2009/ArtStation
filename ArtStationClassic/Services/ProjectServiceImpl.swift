import Foundation

final class ProjectServiceImpl: ProjectService {
    
    let apiManager: ApiManager
    
    init(apiManager: ApiManager = ApiManagerImpl()) {
        self.apiManager = apiManager
    }
    
    func fetchProjects(page: Int, completion: @escaping FetchProjectCompletion) {
        
        let request = ProjectsGetRequest(page: page)
        
        _ = apiManager.makeRequest(
            request: request,
            onSuccess: { [weak self] (responseRoot, task) in
                guard let sself = self else { return }
                
                if let responseRoot = responseRoot,
                    let fetchedProjects = responseRoot.projects {
                    let projects = sself.mapApiResponseToProjects(fetchedProjects: fetchedProjects)
                    completion(projects)
                }
                
        },
            onFailure: { (error, task) in
                print("==== API ERROR: \(error.localizedDescription)")
                completion(nil)
        })
    }
}

extension ProjectServiceImpl {
    
    private func mapApiResponseToProjects(fetchedProjects: [Project]) -> [ProjectViewModel] {
        var projectsViewModels: [ProjectViewModel] = []
        
        
        
        return projectsViewModels
    }
}
