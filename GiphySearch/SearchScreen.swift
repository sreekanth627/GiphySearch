import SwiftUI
import SDWebImageSwiftUI

struct ErrorMessage: Identifiable {
    let id = UUID()
    let message: String
}

struct SearchScreen: View {
    // ViewModel to manage search functionality
    @ObservedObject private var viewModel: SearchViewModel
    // State variables to manage search text, API key, error message, and loading state
    @State private var searchText = ""
    let apiKey: String
    @State private var errorMessage: ErrorMessage?
    @State private var isLoading = false // Control the visibility of the progress view
    @State private var timer: Timer? // Timer to debounce text input
    
    // Initializer to initialize the view model with the provided API key
    init(apiKey: String) {
        self.apiKey = apiKey
        self.viewModel = SearchViewModel(repository: SearchRepository())
    }

    var body: some View {
        NavigationView { // Ensure NavigationView wraps around the content
            VStack {
                // Search bar to input search query
                TextField(NSLocalizedString("enter_search_phrase_placeholder", comment: ""), text: $searchText)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onChange(of: searchText) { newValue in
                        // Cancel previous timer to debounce text input
                        timer?.invalidate()
                        
                        // Start a new timer to trigger API call after a delay
                        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                            // Trigger the API call with the entered text and reset pagination
                            isLoading = true // Show progress view when search starts
                            viewModel.fetchSearchResults(with: newValue, apiKey: apiKey) {
                                isLoading = false // Hide progress view when search finishes
                            }
                        }
                    }

                // Show progress view while searching
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    // Display search results in a list
                    List(viewModel.searchResults, id: \.id) { result in
                        VStack(alignment: .leading, spacing: 8) {
                            // User avatar and display name
                            HStack {
                                AsyncImage(url: URL(string: result.user.avatar_url)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                        .padding(.trailing, 8)
                                } placeholder: {
                                    ProgressView()
                                }

                                Text(result.user.display_name)
                                    .font(.headline)
                            }
                            
                            // Display GIF image
                            WebImage(url: URL(string: result.images.original.url))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .padding(.trailing, 8)

                            // User description
                            Text(result.user.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                        .onAppear {
                            // When the last item is about to be displayed, fetch the next page
                            if result == viewModel.searchResults.last {
                                viewModel.fetchNextPage(with: searchText, apiKey: apiKey)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle()) // Explicitly specify the list style
                }
            }
            .navigationBarTitle(NSLocalizedString("search_title", comment: ""), displayMode: .inline) // Navigation bar title
        }
        .alert(item: $errorMessage) { errorMessage in
            // Display error message alert
            Alert(title: Text(NSLocalizedString("error_title", comment: "")), message: Text(errorMessage.message), dismissButton: .default(Text(NSLocalizedString("error_dismiss_button", comment: ""))))
        }
    }
}
