import Foundation

final class ProjectServiceImpl: ProjectService {
    
    let apiManager: ApiManager
    
    init(apiManager: ApiManager = ApiManagerImpl()) {
        self.apiManager = apiManager
    }
    
    func fetchProjects(page: Int, completion: @escaping FetchProjectCompletion) -> URLSessionDataTask? {
        
        let request = ProjectsGetRequest(page: page)
        
        let task = apiManager.makeRequest(
            request: request,
            onSuccess: { [weak self] (responseRoot, task) in
                guard let sself = self else { return }
                
                if let responseRoot = responseRoot,
                    let fetchedProjects = responseRoot.projects {
                    let projects = sself.mapApiResponseToProjects(fetchedProjects: fetchedProjects)
                    
                    completion(projects)
                } else {
                    print("==== API REPONSE: Incorrect data in response")
                    completion(nil)
                }
        },
            onFailure: { (error, task) in
                print("==== API ERROR: \(error.localizedDescription)")
                completion(nil)
        })
        return task
    }
}

extension ProjectServiceImpl {
    
    private func mapApiResponseToProjects(fetchedProjects: [Project]) -> [ProjectViewModel] {
        var projectsViewModels: [ProjectViewModel] = []
        
        for (index, fetchedProject) in fetchedProjects.enumerated() {
            
            guard
                let id = fetchedProject.id,
                let imageUrlString = fetchedProject.cover?.smallSquareURL,
                let imageUrl = URL(string: imageUrlString),
                let detailLinkString = fetchedProject.permalink,
                let detailLink = URL(string: detailLinkString)
                else {
                    print("=== ⏭ skipped project # \(index) projectID: \(fetchedProject.id ?? -1)")
                    continue
            }
            
            let projectViewModel = ProjectViewModel(
                id: id,
                imageLink: imageUrl,
                image: nil,
                detailLink: detailLink)
            
            projectsViewModels.append(projectViewModel)
        }
        
        return projectsViewModels
    }
}
