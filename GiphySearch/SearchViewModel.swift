import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchResults: [Giphy] = []
    @Published var errorMessage: String?

    private let repository: SearchRepositoryProtocol
    
    var currentPage = 0
    
    func fetchNextPage(with query: String, apiKey: String) {
        // Increment current page
        currentPage += 1
        
        // Fetch data for the next page from the API
        repository.fetchSearchResults(with: query, apiKey: apiKey, page: currentPage) { [weak self] result in
            switch result {
            case .success(let results):
                // Append new data to existing search results
                self?.searchResults.append(contentsOf: results)
                self?.errorMessage = nil
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }

    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }

    func fetchSearchResults(with query: String, apiKey: String, completion: @escaping () -> Void) {
        // Reset current page
        currentPage = 0
        
        // Fetch data from the API
        repository.fetchSearchResults(with: query, apiKey: apiKey, page: currentPage) { [weak self] result in
            switch result {
            case .success(let results):
                // Update search results
                self?.searchResults = results
                self?.errorMessage = nil
            case .failure(let error):
                // Update error message
                self?.errorMessage = error.localizedDescription
            }
            // Call completion handler to signal that search is complete
            completion()
        }
    }
}
