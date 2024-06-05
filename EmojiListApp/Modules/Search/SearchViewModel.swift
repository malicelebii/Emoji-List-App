import Foundation

protocol SearchViewModelDelegate {
    func getEmojisWith(name: String, completion: @escaping ([Emoji]) -> ())
}

class SearchViewModel {
    
    func getEmojisWith(name: String, completion: @escaping ([Emoji]) -> ()) {
        EmojiNetworkManager.shared.getEmojisWith(name: name) { result in
            switch result {
            case .success(let emojis):
                completion(emojis)
                break
            default :
                print("Error")
                break
            }
        }
    }
}
