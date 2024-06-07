import Foundation

protocol FavoritesViewModelDelegate {
    var view: FavoritesViewDelegate? { get set }
    func viewDidLoad()
    func numberOfItemsInSection() -> Int
    func cellForItem(at indexPath: IndexPath) -> Emoji
    func addToFavorites(emoji: Emoji, completion: @escaping () -> ())
    func getAllFavoriteEmojis()
    func deleteFavorite(with name: String)
}

class FavoritesViewModel {
    weak var view: FavoritesViewDelegate?
    let favEmojiCoreDataManager: FavoriteEmojiCoreDataDelegate
    var favEmojis: [Emoji] = [] {
        didSet {
            self.view?.reloadCollectionView()
        }
    }
    
    init(view: FavoritesViewDelegate? = nil, favEmojiCoreDataManager: FavoriteEmojiCoreDataDelegate = FavoriteEmojiCoreDataManager.shared ) {
        self.view = view
        self.favEmojiCoreDataManager = favEmojiCoreDataManager
    }
}

extension FavoritesViewModel: FavoritesViewModelDelegate {
    func viewDidLoad() {
        self.view?.configureCollectionView()
    }
    
    func numberOfItemsInSection() -> Int {
        return favEmojis.count
    }
    
    func cellForItem(at indexPath: IndexPath) -> Emoji {
        return favEmojis[indexPath.item]
    }
    
    func addToFavorites(emoji: Emoji, completion: @escaping () -> ()) {
        self.favEmojiCoreDataManager.save(favoriteEmoji: emoji) { result in
            switch result {
            case .success():
                completion()
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
        }
    }
    
    func getAllFavoriteEmojis() {
        self.favEmojiCoreDataManager.getFavoriteEmojis { result in
            switch result {
            case .success(let favEmojis):
                var emojis = [Emoji]()
                favEmojis.forEach { favEmoji in
                    let emoji = Emoji(name: favEmoji.name, character: favEmoji.character)
                    emojis.append(emoji)
                }
                self.favEmojis = emojis
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
        }
    }
    
    func deleteFavorite(with name: String) {
        self.favEmojiCoreDataManager.deleteEmojiWith(name: name) { result in
            switch result {
            case .success():
                self.view?.showToast(with: "You have deleted emoji successfully!")
                self.getAllFavoriteEmojis()
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
            
        }
    }
}
