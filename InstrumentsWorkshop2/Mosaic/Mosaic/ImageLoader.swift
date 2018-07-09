import UIKit

protocol ImageLoaderDelegate: class {
  func imageLoader(_ loader: ImageLoader, didLoadImage image: UIImage)
  func imageLoader(_ loader: ImageLoader, failedLoadWithError error: Error)
}

class ImageLoader {
  weak var delegate: ImageLoaderDelegate?
  var currentTask: URLSessionDataTask?

  func loadCat(atIndexPath indexPath: IndexPath) {
    let location = "https://cataas.com/cat?idx=s\(indexPath.section)r\(indexPath.row)"

    if let image = ImageCache.getImageForKey(location) {
      delegate?.imageLoader(self, didLoadImage: image)
      return
    }

    let url = URL(string: location)!
    currentTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      guard let strongSelf = self else {
        return
      }

      if let error = error {
        strongSelf.delegate?.imageLoader(strongSelf, failedLoadWithError: error)
      }

      guard let data = data,
        let image = UIImage(data: data) else {
          return
      }

      ImageCache.addImage(image, forKey: location)
      strongSelf.delegate?.imageLoader(strongSelf, didLoadImage: image)
    }

    currentTask?.resume()
  }

  func cancel() {
    currentTask?.cancel()
    currentTask = nil
  }
}

class ImageCache {
  private static var cache = [String: UIImage]()

  static func addImage(_ image: UIImage, forKey key: String) {
    cache[key] = image
  }

  static func getImageForKey(_ key: String) -> UIImage? {
    return cache[key]
  }
}
