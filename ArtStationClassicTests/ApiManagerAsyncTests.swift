import XCTest
@testable import ArtStationClassic

class ApiManagerAsyncTests: XCTestCase {
    
    var sutApiManager: ApiManager!
    
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
            
            print("\n===\n")
            receivedResponse = response
            promise.fulfill()
        }) { (apiError, task) in
            XCTFail()
            promise.fulfill()
            print("==== sutApiManager.makeRequest callback FAILURE: \(apiError.localizedDescription)")
        }
        waitForExpectations(timeout: 5)
        // ASSERT
        
        XCTAssertEqual(receivedResponse?.projects?.count, expectedProjectsCount)
    }
    
    
}
