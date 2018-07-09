import Foundation
import SwiftyJSON

struct Attendee: Decodable {
  let id: Int
  let name: String
  let expertise: Expertise
  
  init(from json: JSON) {
    self.id = json["id"].intValue
    self.name = json["name"].stringValue
    self.expertise = Expertise(from: json["expertise"])
  }
}
