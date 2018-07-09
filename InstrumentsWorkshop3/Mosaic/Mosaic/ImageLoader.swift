import UIKit
import os.signpost

protocol ImageLoaderDelegate: class {
  func imageLoader(_ loader: ImageLoader, didLoadImage image: UIImage)
  func imageLoader(_ loader: ImageLoader, failedLoadWithError error: Error)
}

fileprivate let imageLogger = OSLog(subsystem: "com.mosaic", category: "ImageLoader")
fileprivate let imageEventLogger = OSLog(subsystem: "com.mosaic", category: .pointsOfInterest)

class ImageLoaderQueue {
  static let shared = ImageLoaderQueue()

  var loaders = Set<ImageLoader>()

  func enqueue(_ loader: ImageLoader) {
    loaders.insert(loader)
  }

  func remove(_ loader: ImageLoader) {
    loaders.remove(loader)
  }
}

class ImageLoader: NSObject {
  weak var delegate: ImageLoaderDelegate?
  var currentTask: URLSessionDataTask?

  var signpostID: OSSignpostID {
    return OSSignpostID(log: imageLogger, object: self)
  }

  deinit {
    cancel()
  }

  func loadCat(atIndexPath indexPath: IndexPath) {
    ImageLoaderQueue.shared.enqueue(self)
    let location = "https://cataas.com/cat?idx=s\(indexPath.section)r\(indexPath.row)"

    os_signpost(type: .begin, log: imageLogger, name: "Image download",
                signpostID: signpostID, "Download started")

    if let image = ImageCache.getImageForKey(location) {
      delegate?.imageLoader(self, didLoadImage: image)
      os_signpost(type: .end, log: imageLogger, name: "Image download",
                  signpostID: signpostID, "Download completed through cache hit")
      return
    }

    let url = URL(string: location)!
    currentTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      guard let strongSelf = self else {
        return
      }

      defer {
        ImageLoaderQueue.shared.remove(strongSelf)
      }

      if let error = error {
        os_signpost(type: .end, log: imageLogger, name: "Image download",
                    signpostID: strongSelf.signpostID, "Download failed with error %s", error.localizedDescription)
        strongSelf.delegate?.imageLoader(strongSelf, failedLoadWithError: error)
      }

      guard let data = data,
        let image = UIImage(data: data) else {
          return
      }

      os_signpost(type: .end, log: imageLogger, name: "Image download",
                  signpostID: strongSelf.signpostID, "Download completed through network")
      ImageCache.addImage(image, forKey: location)
      strongSelf.delegate?.imageLoader(strongSelf, didLoadImage: image)
    }

    currentTask?.resume()
  }

  func cancel() {
    os_signpost(type: .event, log: imageEventLogger, name: "Image download", signpostID: signpostID, "Cancelled")
    currentTask?.suspend()
    currentTask?.cancel()
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
