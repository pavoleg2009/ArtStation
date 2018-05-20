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
    
    private func mapIconsToOptionSet(icons: Icons) -> IconsOptions {
        var options: IconsOptions = []
        if icons.image ?? false { options.insert(.image)}
        if icons.video ?? false { options.insert(.video)}
        if icons.model3d ?? false { options.insert(.model3d)}
        if icons.marmoset ?? false { options.insert(.marmoset)}
        if icons.pano ?? false { options.insert(.pano)}
        
        return options
    }
    
    private func mapApiResponseToProjects(fetchedProjects: [Project]) -> [ProjectViewModel] {
        var projectsViewModels: [ProjectViewModel] = []
        
        for (index, fetchedProject) in fetchedProjects.enumerated() {
            
            guard
                let id = fetchedProject.id,
                let detailLinkString = fetchedProject.permalink,
                let detailLink = URL(string: detailLinkString),
                // covers
                let image200LinkString = fetchedProject.cover?.microSquareImageURL,
                let image200Link = URL(string: image200LinkString),
                let image400LinkString = fetchedProject.cover?.thumbURL,
                let image400Link = URL(string: image400LinkString),
                let image800LinkString = fetchedProject.cover?.smallSquareURL,
                let image800Link = URL(string: image800LinkString)
            
                else {
                    print("=== ⏭ skipped project # \(index) projectID: \(fetchedProject.id ?? -1)")
                    continue
            }
            
            let options: IconsOptions
            if let icons = fetchedProject.icons {
                options = mapIconsToOptionSet(icons: icons)
            } else {
                options = []
            }
            
            let projectViewModel = ProjectViewModel(
                id: id,
                title: fetchedProject.title ?? "",
                image200Link: image200Link,
                image400Link: image400Link,
                image800Link: image800Link,
                detailLink: detailLink,
                iconOptions: options)
            
            projectsViewModels.append(projectViewModel)
        }
        
        return projectsViewModels
    }
}
