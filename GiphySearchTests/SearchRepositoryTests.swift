import XCTest
@testable import GiphySearch

class SearchRepositoryTests: XCTestCase {
    
    var searchRepository: SearchRepository!
    
    override func setUp() {
        super.setUp()
        // Initialize the search repository
        searchRepository = SearchRepository()
    }
    
    override func tearDown() {
        // Clean up resources
        searchRepository = nil
        super.tearDown()
    }
    
    func testFetchSearchResults() {
        // Prepare the test data
        let query = "love"
        let apiKey = "SMQR4kNVh64J4oM4jnP4qebsAvmGMIf4"
        let page = 0
        
        // Create an expectation for the async call
        let expectation = XCTestExpectation(description: "Fetch search results")
        
        // Perform the asynchronous call to fetch search results
        searchRepository.fetchSearchResults(with: query, apiKey: apiKey, page: page) { result in
            switch result {
            case .success(let searchResults):
                // Check if search results are not empty
                XCTAssertFalse(searchResults.isEmpty, "Search results should not be empty")
            case .failure(let error):
                // Fail the test if there's an error
                XCTFail("Failed to fetch search results: \(error.localizedDescription)")
            }
            
            // Fulfill the expectation to indicate the completion of the async call
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled within a certain timeout
        wait(for: [expectation], timeout: 10.0) // Adjust the timeout as needed
    }
}
