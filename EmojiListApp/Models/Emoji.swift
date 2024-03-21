import Foundation

struct Emoji: Codable {
    var name: String?
    var character: String?
    var group: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case character = "character"
        case group = "group"
    }
}
