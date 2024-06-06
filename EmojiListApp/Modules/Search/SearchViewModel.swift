import Foundation

protocol SearchViewModelDelegate {
    var view: SearchViewDelegate? { get set }
    func getEmojisWith(name: String, completion: @escaping ([Emoji]) -> ())
    func viewDidLoad()
    func numberOfItemsInSection() -> Int
    func cellForItem(at indexPath: IndexPath) -> Emoji
    func didSelectItem(at: Int) -> Emoji
}

class SearchViewModel: SearchViewModelDelegate {
    weak var view: SearchViewDelegate?
    let networkManager: EmojiNetworkManager
    var emojis: [Emoji] = [] {
        didSet {
            self.view?.reloadCollectionView()
        }
    }
    
    init(view: SearchViewDelegate? = nil, networkManager: EmojiNetworkManager = EmojiNetworkManager.shared) {
        self.view = view
        self.networkManager = networkManager
    }
    
    func getEmojisWith(name: String, completion: @escaping ([Emoji]) -> ()) {
        networkManager.getEmojisWith(name: name) { result in
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
    
    func numberOfItemsInSection() -> Int {
        return emojis.count
    }
    
    func cellForItem(at indexPath: IndexPath) -> Emoji {
        return emojis[indexPath.item]
    }
    
    func didSelectItem(at: Int) -> Emoji {
        return emojis[at]
    }
    
    func viewDidLoad() {
        view?.configureCollectionView()
    }
}
