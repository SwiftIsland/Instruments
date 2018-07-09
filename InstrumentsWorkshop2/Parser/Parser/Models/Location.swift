import Foundation
import SwiftyJSON

struct Location: Decodable {
  let id: Int
  let name: String
  let address: String
  let latitude: Double
  let longitude: Double
  
  init(from json: JSON) {
    self.id = json["id"].intValue
    self.name = json["name"].stringValue
    self.address = json["address"].stringValue
    self.latitude = json["latitude"].doubleValue
    self.longitude = json["longitude"].doubleValue
  }
}
