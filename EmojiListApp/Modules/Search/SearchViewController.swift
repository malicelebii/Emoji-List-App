import UIKit

protocol SearchViewDelegate: AnyObject {
    func reloadCollectionView()
    func configureCollectionView()
}

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var emojiCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    var searchViewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchViewModel.view = self
        searchViewModel.viewDidLoad()
    }

    func configureCollectionView(){
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
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

extension SearchViewController: SearchViewDelegate {
    func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.emojiCollectionView.reloadData()
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchViewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.cellIdentifier, for: indexPath) as! EmojiCell
        let emoji = searchViewModel.cellForItem(at: indexPath)
        cell.configureCell(emoji: emoji)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoji = searchViewModel.didSelectItem(at: indexPath.item)
        performSegue(withIdentifier: "toDetailsVC", sender: emoji)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destination = segue.destination as! DetailsViewController
            destination.emoji = sender as? Emoji
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchViewModel.searchTextDidChange(searchText: searchText)
    }
}


