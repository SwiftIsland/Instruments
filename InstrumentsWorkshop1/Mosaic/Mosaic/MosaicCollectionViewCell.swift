import UIKit

class MosaicCollectionViewCell: UICollectionViewCell {
  static let identifier = String(describing: MosaicCollectionViewCell.self)

  let imageView = UIImageView()

  required init?(coder aDecoder: NSCoder) {
    fatalError("Not implemented")
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(imageView)
    imageView.backgroundColor = .red

    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.rightAnchor.constraint(equalTo: rightAnchor),
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
      imageView.leftAnchor.constraint(equalTo: leftAnchor)])
  }
}

extension MosaicCollectionViewCell: ImageLoaderDelegate {
  func imageLoader(_ loader: ImageLoader, didLoadImage image: UIImage) {
    DispatchQueue.main.async {
      self.imageView.image = image
    }
  }

  func imageLoader(_ loader: ImageLoader, failedLoadWithError error: Error) {
    DispatchQueue.main.async {
      self.imageView.image = nil
    }
  }
}
