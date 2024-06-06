import Foundation

protocol SearchViewModelDelegate {
    var view: SearchViewDelegate? { get set }
    func getEmojisWith(name: String, completion: @escaping ([Emoji]) -> ())
    func viewDidLoad()
    func numberOfItemsInSection() -> Int
    func cellForItem(at indexPath: IndexPath) -> Emoji
    func didSelectItem(at: Int) -> Emoji
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
