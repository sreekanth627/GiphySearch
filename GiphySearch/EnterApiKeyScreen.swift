import SwiftUI

struct EnterApiKeyScreen: View {
    // State properties to store the API key and validation status
    @State private var apiKey: String = ""
    @State private var isApiKeyValid: Bool = true
    @State private var navigateToNextScreen = false // State property to control navigation to the next screen
    
    var body: some View {
        NavigationView {
            VStack {
                // Text field for entering the API key
                TextField(NSLocalizedString("enter_api_key_placeholder", comment: ""), text: $apiKey)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                // Error message displayed if the API key is invalid
                if !isApiKeyValid {
                    Text(NSLocalizedString("invalid_api_key_message", comment: ""))
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                // Button to proceed to the next screen
                Button(NSLocalizedString("proceed_button_title", comment: "")) {
                    if !apiKey.isEmpty {
                        navigateToNextScreen = true
                    } else {
                        isApiKeyValid = false
                    }
                }
                .disabled(apiKey.isEmpty)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                .padding()
                
                // Navigation link to the search screen
                NavigationLink(destination: SearchScreen(apiKey: apiKey), isActive: $navigateToNextScreen) {
                    EmptyView()
                }
                .hidden() // Hide the navigation link by default
            }
            .navigationBarTitle(NSLocalizedString("enter_api_key_title", comment: ""), displayMode: .inline) // Set the navigation bar title
        }
    }
}

struct EnterApiKeyScreen_Previews: PreviewProvider {
    static var previews: some View {
        EnterApiKeyScreen()
    }
}
