import Foundation

// Protocol defining the interface for a search repository
protocol SearchRepositoryProtocol {
    // Alias for completion handler type
    typealias FetchSearchResultsCompletion = (Result<[Giphy], Error>) -> Void
    
    // Method to fetch search results
    func fetchSearchResults(with query: String, apiKey: String, page: Int, completion: @escaping FetchSearchResultsCompletion)
}

// Implementation of the search repository protocol
class SearchRepository: SearchRepositoryProtocol {
    
    // Method to fetch search results from the Giphy API
    func fetchSearchResults(with query: String, apiKey: String, page: Int, completion: @escaping FetchSearchResultsCompletion) {
        
        // Endpoint for the Giphy search API
        let endpoint = "https://api.giphy.com/v1/gifs/search"
        
        // Construct URL components
        var components = URLComponents(string: endpoint)!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: "20"), // Example limit
            URLQueryItem(name: "offset", value: "\(page * 20)") // Example pagination
        ]
        
        // Create URL from components
        guard let url = components.url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        // Create URL request
        let request = URLRequest(url: url)
        
        // Perform URL session task to fetch data
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                // Check for data and response errors
                guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                    completion(.failure(error ?? URLError(.unknown)))
                    return
                }
                
                // Check for successful HTTP status code
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }
                
                do {
                    // Decode JSON data into search response object
                    let decoder = JSONDecoder()
                    let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                    completion(.success(searchResponse.data))
                } catch {
                    // Handle decoding errors
                    completion(.failure(error))
                }
            }
        }
        
        // Resume the data task
        task.resume()
    }
}
