import Foundation

protocol FavoritesViewModelDelegate {
    var view: FavoritesViewDelegate? { get set }
    func viewDidLoad()
    func numberOfItemsInSection() -> Int
    func cellForItem(at indexPath: IndexPath) -> Emoji
    func addToFavorites(emoji: Emoji, completion: @escaping () -> ())
    func getAllFavoriteEmojis(completion: @escaping ([Emoji]) -> ())
    func deleteFavoriteWith(name: String, completion: @escaping () -> ())
}

class FavoritesViewModel {
    weak var view: FavoritesViewDelegate?
    let favEmojiCoreDataManager: FavoriteEmojiCoreDataManager
    var favEmojis: [Emoji] = [] {
        didSet {
            self.view?.reloadCollectionView()
        }
    }
    
    init(view: FavoritesViewDelegate? = nil, favEmojiCoreDataManager: FavoriteEmojiCoreDataManager = FavoriteEmojiCoreDataManager.shared ) {
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
        self.favEmojiCoreDataManager.save(favoriteEmoji: emoji) {
            completion()
        }
    }
    
    func getAllFavoriteEmojis(completion: @escaping ([Emoji]) -> ()) {
        self.favEmojiCoreDataManager.getFavoriteEmojis { favEmojis in
            var emojis = [Emoji]()
            favEmojis.forEach { favEmoji in
                let emoji = Emoji(name: favEmoji.name, character: favEmoji.character)
                emojis.append(emoji)
            }
            completion(emojis)
        }
    }
    
    func deleteFavoriteWith(name: String, completion: @escaping () -> ()) {
        self.favEmojiCoreDataManager.deleteEmojiWith(name: name) {
            completion()
        }
    }
}
