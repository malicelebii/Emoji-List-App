import Foundation

protocol NetworkRequestDelegate {
    func getEmojisWith(name: String, completionHandler: @escaping (Result<[Emoji],NetworkErrorEnum>) -> ())
}

final class EmojiNetworkManager: NetworkRequestDelegate {
    static let shared = EmojiNetworkManager()
    static var apiKey = ""
    
    
    func getEmojisWith(name: String, completionHandler: @escaping (Result<[Emoji],NetworkErrorEnum>) -> ()) {
        let baseURL = "https://api.api-ninjas.com/v1/emoji?name="
        let urlWithName = baseURL + name
        guard let url = URL(string: urlWithName) else {
            completionHandler(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(EmojiNetworkManager.apiKey, forHTTPHeaderField: "X-Api-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else { completionHandler(.failure(.badRequest)); return }
            guard let data = data else { return  }
            
            do {
                 let emojis = try JSONDecoder().decode([Emoji].self, from: data)
                completionHandler(.success(emojis))
            } catch {
                completionHandler(.failure(.decodeError))
            }
            
        }
        task.resume()
    }
}

enum NetworkErrorEnum: String, Error {
    case badURL = "Url is not valid"
    case badRequest = "Request invalid"
    case decodeError = "Data cannot be decoded"
}
