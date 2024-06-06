import UIKit

protocol FavoritesViewDelegate: AnyObject {
    func reloadCollectionView()
}

class FavoritesViewController: UIViewController {
    let favoritesViewModel = FavoritesViewModel()
    
    var favEmojisCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    var favEmojis = [Emoji]() {
        didSet {
            DispatchQueue.main.async {
                self.favEmojisCollectionView.reloadData()
            }
        }
    }
    var selectedCellIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favEmojisCollectionView.dataSource = self
        favEmojisCollectionView.delegate = self
        configureCollectionView()
        setupLongGestureToDeleteFavEmoji()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        favoritesViewModel.getAllFavoriteEmojis { emojis in
            self.favEmojis = emojis
        }
    }
    
    func configureCollectionView() {
        view.addSubview(favEmojisCollectionView)
        setupCollectionViewLayout()
        favEmojisCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.cellIdentifier)
        setupCollectionViewConstraints()
    }
    
    func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 25
        favEmojisCollectionView.collectionViewLayout = layout
    }
    
    func setupCollectionViewConstraints() {
        favEmojisCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favEmojisCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            favEmojisCollectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 20),
            favEmojisCollectionView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            favEmojisCollectionView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    func setupDeleteImagePress(cell: EmojiCell) {
        selectedCellIndex = cell.index
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedDeleteIcon(_ :)))
        cell.deleteImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func tappedDeleteIcon(_ gestureRecognizer: UIGestureRecognizer) {
        let ac = UIAlertController(title: "Delete", message: "Are you sure to delete this emoji from favorites ?", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.favoritesViewModel.deleteFavoriteWith(name: (self.favEmojis[self.selectedCellIndex!].name)!) {
                self.favoritesViewModel.getAllFavoriteEmojis { emojis in
                    self.favEmojis = emojis
                    self.view.showToast(message: "You have deleted emoji successfully")
                }
            }
        }))
        present(ac, animated: true)
    }
   
 }

extension FavoritesViewController: FavoritesViewDelegate {
    func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.favEmojisCollectionView.reloadData()
        }
    }
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favEmojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.cellIdentifier, for: indexPath) as! EmojiCell
        let emoji = favEmojis[indexPath.row]
        emojiCell.configureCell(emoji: emoji)
        setupDeleteImagePress(cell: emojiCell)
        emojiCell.index = indexPath.row
        return emojiCell
    }
    
}

extension FavoritesViewController: UIGestureRecognizerDelegate {
    func setupLongGestureToDeleteFavEmoji() {
        let lgr = UILongPressGestureRecognizer(target: self, action: #selector(pressedLong(gestureRecognizer:)))
        lgr.delegate = self
        lgr.minimumPressDuration = 0.5
        lgr.delaysTouchesBegan = true
        favEmojisCollectionView.addGestureRecognizer(lgr)
    }
    
    @objc func pressedLong(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != .began { return }
 
        let touchPoint = gestureRecognizer.location(in: favEmojisCollectionView)
        if let row = favEmojisCollectionView.indexPathForItem(at: touchPoint) {
            if let cell = favEmojisCollectionView.cellForItem(at: row) as? EmojiCell {
                cell.showDeleteIcon()
                cell.shake()
                setupDeleteImagePress(cell: cell)
            }
        }
    }
}



