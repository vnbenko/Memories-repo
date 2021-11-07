import Foundation

struct User {
    
    let uid: String
    let username: String
    let profileImage: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImage = dictionary["profileImage"] as? String ?? ""
    }
}
