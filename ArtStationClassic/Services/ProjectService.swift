import Foundation

typealias FetchProjectCompletion = ([ProjectViewModel]?) -> Void

protocol ProjectService {
    func fetchProjects(page: Int, completion: @escaping FetchProjectCompletion)
}
