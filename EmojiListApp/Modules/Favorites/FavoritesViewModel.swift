import Foundation

protocol FavoritesViewModelDelegate {
    func addToFavorites(emoji: Emoji, completion: @escaping () -> ())
    func getAllFavoriteEmojis(completion: @escaping ([Emoji]) -> ())
    func deleteFavoriteWith(name: String, completion: @escaping () -> ())
}

class FavoritesViewModel {
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
