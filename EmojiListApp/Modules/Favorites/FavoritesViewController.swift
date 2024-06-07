import UIKit

protocol FavoritesViewDelegate: AnyObject {
    func reloadCollectionView()
    func configureCollectionView()
    func showToast(with: String)
}

class FavoritesViewController: UIViewController {
    let favoritesViewModel = FavoritesViewModel()
    
    var favEmojisCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    
    var selectedCellIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesViewModel.view = self
        favoritesViewModel.viewDidLoad()
        setupLongGestureToDeleteFavEmoji()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        favoritesViewModel.getAllFavoriteEmojis { emojis in
            self.favoritesViewModel.favEmojis = emojis
        }
    }
    
    func configureCollectionView() {
        favEmojisCollectionView.dataSource = self
        favEmojisCollectionView.delegate = self
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
            self.favoritesViewModel.deleteFavoriteWith(name: (self.favoritesViewModel.favEmojis[self.selectedCellIndex!].name)!) {
                self.favoritesViewModel.getAllFavoriteEmojis { emojis in
                    self.favoritesViewModel.favEmojis = emojis
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
    
    func showToast(with message: String) {
        self.view.showToast(message: message)
    }
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.favoritesViewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.cellIdentifier, for: indexPath) as! EmojiCell
        let emoji = self.favoritesViewModel.cellForItem(at: indexPath)
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



