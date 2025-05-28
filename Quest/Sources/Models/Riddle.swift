
import Foundation

struct Riddle: Identifiable, Decodable {
    let id: Int
    let question: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
}
