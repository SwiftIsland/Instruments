import Foundation
import SwiftyJSON

struct Workshop: Decodable {
  let id: Int
  let name: String
  let mentor: Mentor
  
  init(from json: JSON) {
    self.id = json["id"].intValue
    self.name = json["name"].stringValue
    self.mentor = Mentor(from: json["mentor"])
  }
}
