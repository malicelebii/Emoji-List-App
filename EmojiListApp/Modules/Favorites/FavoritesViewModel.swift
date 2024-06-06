import Foundation

protocol FavoritesViewModelDelegate {
    var view: FavoritesViewDelegate? { get set }
    func viewDidLoad()
    func addToFavorites(emoji: Emoji, completion: @escaping () -> ())
    func getAllFavoriteEmojis(completion: @escaping ([Emoji]) -> ())
    func deleteFavoriteWith(name: String, completion: @escaping () -> ())
}

class FavoritesViewModel {
    weak var view: FavoritesViewDelegate?
    var favEmojis: [Emoji] = [] {
        didSet {
            self.view?.reloadCollectionView()
        }
    }
    
    init(view: FavoritesViewDelegate? = nil) {
        self.view = view
    }
}

extension FavoritesViewModel: FavoritesViewModelDelegate {
    func viewDidLoad() {
        self.view?.configureCollectionView()
    }
    
    func addToFavorites(emoji: Emoji, completion: @escaping () -> ()) {
        FavoriteEmojiCoreDataManager.shared.save(favoriteEmoji: emoji) {
            completion()
        }
    }
    
    func getAllFavoriteEmojis(completion: @escaping ([Emoji]) -> ()) {
        FavoriteEmojiCoreDataManager.shared.getFavoriteEmojis { favEmojis in
            var emojis = [Emoji]()
            favEmojis.forEach { favEmoji in
                let emoji = Emoji(name: favEmoji.name, character: favEmoji.character)
                emojis.append(emoji)
            }
            completion(emojis)
        }
    }
    
    func deleteFavoriteWith(name: String, completion: @escaping () -> ()) {
        FavoriteEmojiCoreDataManager.shared.deleteEmojiWith(name: name) {
            completion()
        }
    }
}
