import XCTest
@testable import ArtStationClassic

class ApiManagerAsyncImplTests: XCTestCase {
    
    var sutApiManager: ApiManagerImpl!
    
    override func setUp() {
        super.setUp()
        sutApiManager = ApiManagerImpl(session: URLSession(configuration: .default),
                                       parser: JSONParser())
    }
    
    override func tearDown() {
        sutApiManager = nil
        super.tearDown()
    }
    
    func test_makeRequest_projectRequestShouldReturn50Projects() {
        // ARRANGE
        let testRequest = ProjectsGetRequest(page: 1)
        let promise = expectation(description: "Callback executed")
        let expectedProjectsCount = 50
        var receivedResponse: ProjectsRequestResponse?
        
        // ACT
        let _ = sutApiManager.makeRequest(request: testRequest, onSuccess: { (response, task) in
            
            receivedResponse = response
            promise.fulfill()
            
        }) { (apiError, task) in
            
            XCTFail()
            promise.fulfill()
            print("==== sutApiManager.makeRequest callback FAILURE: \(apiError.localizedDescription)")
        }
        
        // ASSERT
        waitForExpectations(timeout: 5)
        XCTAssertEqual(receivedResponse?.projects?.count, expectedProjectsCount)
    }
    
    
}
