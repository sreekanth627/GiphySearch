struct SearchResponse: Decodable {
    let data: [Giphy]
}

struct Giphy : Decodable, Equatable {
    static func == (lhs: Giphy, rhs: Giphy) -> Bool {
        lhs.id == rhs.id
    }
    
    let id : String
    let user: User
    let images: Images
    
    struct User: Decodable {
        let avatar_url: String
        let banner_image: String
        let banner_url: String
        let profile_url: String
        let username: String
        let display_name: String
        let description: String
        let instagram_url: String
        let website_url: String
        let is_verified: Bool

    }
    
    struct Images : Decodable {
        let original : Original
    }
    
    struct Original: Decodable {
        let url : String
    }
    
}




