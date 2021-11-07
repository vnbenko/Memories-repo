import Foundation
import Firebase

extension Database {
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        Database.database(url: Constants.shared.databaseUrlString).reference()
            .child("users")
            .child(uid)
            .observeSingleEvent(of: .value) { snapshot in
                guard let userDictionary = snapshot.value as? [String: Any] else { return }
                let user = User(uid: uid, dictionary: userDictionary)
                completion(user)
            } withCancel: { error in
                print("Failed to fetch users for posts: ", error)
            }
    }
}
