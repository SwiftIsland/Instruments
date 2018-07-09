import Foundation
import SwiftyJSON

struct Expertise: Decodable {
  let id: Int
  let name: String
  
  init(from json: JSON) {
    self.id = json["id"].intValue
    self.name = json["name"].stringValue
  }
}
