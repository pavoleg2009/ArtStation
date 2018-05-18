import XCTest
@testable import ArtStationClassic

class ProjectsServiceImplTests: XCTestCase {
    
    var sutProjectService: ProjectServiceImpl!
    
    override func setUp() {
        super.setUp()
        
        sutProjectService = ProjectServiceImpl(apiManager: ApiManagerMock_SuccessProjectsResult())
    }
    
    override func tearDown() {
        sutProjectService = nil
        super.tearDown()
    }
    
    func test_fetchProjects_callsCompletionWith50ViewModels() {
        // ARRANGE
        let expeectedViewModelsCount = 50
        let promise = expectation(description: "completion called")
        var viewModels: [ProjectViewModel] = []
        
        // ACT
        sutProjectService.fetchProjects(page: 1) { fetchedViewModels in
            
            guard let fetchedViewModels = fetchedViewModels  else {
                XCTFail()
                return
            }
            viewModels = fetchedViewModels            
            promise.fulfill()
        }
        
        // ASSERT
        waitForExpectations(timeout: 5)
        XCTAssertEqual(viewModels.count, expeectedViewModelsCount)
    }

    
}
