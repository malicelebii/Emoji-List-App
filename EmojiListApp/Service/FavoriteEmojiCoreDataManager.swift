import Foundation
import CoreData

protocol FavoriteEmojiCoreDataDelegate {
    func save(favoriteEmoji: Emoji, completion: @escaping (Result<Void, CoreDataErrorEnum>) -> ())
    func getFavoriteEmojis(completion: @escaping (Result<[FavEmoji], CoreDataErrorEnum>) -> ())
    func deleteEmojiWith(name: String, completion: @escaping (Result<Void, CoreDataErrorEnum>) -> ())
}

class FavoriteEmojiCoreDataManager: FavoriteEmojiCoreDataDelegate {
    static let shared = FavoriteEmojiCoreDataManager()
    
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "FavoriteEmojiModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("Error has occured while loading persistent store: \(error.localizedDescription)")
            }
        }
    }
    
    func save(favoriteEmoji: Emoji, completion: @escaping () -> ()) {
        persistentContainer.performBackgroundTask { context in
            let emoji = FavEmoji(context: context)
            emoji.name = favoriteEmoji.name
            emoji.character = favoriteEmoji.character
            
            do {
                try context.save()
                print("kaydeettikk")
                completion()
            } catch {
             print(error)
            }
        }
    }
    
    func getFavoriteEmojis(completion: @escaping ([FavEmoji]) -> ()) {
        let request: NSFetchRequest<FavEmoji> = FavEmoji.fetchRequest()
        do {
            let emojis = try viewContext.fetch(request)
            completion(emojis)
        } catch  {
            print(error)
        }
    }
    
    func deleteEmojiWith(name: String,completion: @escaping () -> ()) {
        let fetchRequest: NSFetchRequest<FavEmoji> = FavEmoji.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)
            
            do {
                let results = try viewContext.fetch(fetchRequest)
                for emoji in results {
                    viewContext.delete(emoji)
                }
                
                try viewContext.save() // Değişiklikleri kaydet
                print("Emoji with name \(name) deleted successfully")
                completion()
            } catch {
                print("Error deleting emoji: \(error)")
            }
    }
    
    func deleteAllFavoriteEmojis() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavEmoji")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(deleteRequest)
            print("deleted all ")
        } catch {
            print("errorrrrr")
        }
    }
    
    
}
