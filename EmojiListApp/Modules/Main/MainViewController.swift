import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var emojis = [Emoji]() {
        didSet {
            DispatchQueue.main.async {
                self.emojiCollectionView.reloadData()
            }
        }
    }
    
    var counter: Counter?
    var searchViewModel = SearchViewModel()
    
    
    var emojiCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        searchBar.delegate = self
        configureCollectionView()
    }

    func configureCollectionView(){
        view.addSubview(emojiCollectionView)
        setupCollectionViewLayout()
        emojiCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.cellIdentifier)
        setupCollectionViewConstraints()
    }
    
    func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 25
        emojiCollectionView.collectionViewLayout = layout
    }
    
    func setupCollectionViewConstraints() {
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emojiCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor,constant: 25),
            emojiCollectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            emojiCollectionView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
        ])
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.cellIdentifier, for: indexPath) as! EmojiCell
        let emoji = emojis[indexPath.row]
        cell.configureCell(emoji: emoji)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoji = emojis[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: emoji)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destination = segue.destination as! DetailsViewController
            destination.emoji = sender as? Emoji
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count != 0 else { emojis.removeAll(); return }
        guard searchText.count > 2 else { return }
        
        counter?.timer?.invalidate()
        counter = Counter(delay: 1) {
            self.searchViewModel.getEmojisWith(name: searchText) { emojis in
                self.emojis = emojis
            }
        }
        counter?.call()
    }
}


