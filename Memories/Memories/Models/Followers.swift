import UIKit

struct Followers {
    
    let user: User
    let followingDate: Date
    
    var id: String?
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        let secondsFrom1970 = dictionary["followingDate"] as? Double ?? 0
        self.followingDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
    
}
