import UIKit

class CustomImageView: UIImageView {
    
    var imageCache = [String: UIImage]()
    var lastUrlUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        lastUrlUsedToLoadImage = urlString

        self.image = nil

        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch post image: ", error)
                return
            }
            //we check dublicating url
            if url.absoluteString != self.lastUrlUsedToLoadImage {
                return
            }
            
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            self.imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
        }.resume()
    }
}
