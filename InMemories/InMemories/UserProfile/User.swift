import Foundation

struct User {
    let userName: String
    let userPhoto: String
    
    init(dictionary: [String: Any]) {
        self.userName = dictionary["userName"] as? String ?? ""
        self.userPhoto = dictionary["userPhoto"] as? String ?? ""
    }
}
