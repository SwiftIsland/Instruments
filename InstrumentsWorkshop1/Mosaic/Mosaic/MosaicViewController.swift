import UIKit

class MosaicViewController: UIViewController {
  let collectionViewLayout = MosaicCollectionViewLayout()
  lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
  var numberOfSections = 1

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(MosaicCollectionViewCell.self, forCellWithReuseIdentifier: MosaicCollectionViewCell.identifier)
    view.addSubview(collectionView)

    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.leftAnchor.constraint(equalTo: view.leftAnchor)])

    collectionView.dataSource = self
    collectionView.delegate = self
  }
}

extension MosaicViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return numberOfSections
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 50
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MosaicCollectionViewCell.identifier, for: indexPath) as! MosaicCollectionViewCell

    let imageLoader = ImageLoader()
    imageLoader.delegate = cell
    imageLoader.loadCat(atIndexPath: indexPath)

    return cell
  }
}

extension MosaicViewController: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (scrollView.contentOffset.y + view.bounds.height) - scrollView.contentSize.height > -100 {
      numberOfSections += 1
      collectionView.reloadData()
    }
  }
}
