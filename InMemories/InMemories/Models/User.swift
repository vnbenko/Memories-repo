import Foundation

struct User {
    
    let username: String
    let profileImage: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImage = dictionary["profileImage"] as? String ?? ""
    }
}
