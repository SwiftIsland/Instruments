import Foundation
import SwiftyJSON

struct Conference: Decodable {
  let id: Int
  let name: String
  let location: Location
  let attendees: [Attendee]
  let workshops: [Workshop]
  
  init(from json: JSON) {
    self.id = json["id"].intValue
    self.name = json["name"].stringValue
    self.location = Location(from: json["location"])
    self.attendees = json["attendees"].arrayValue.map { attendeeJSON in
      return Attendee(from: attendeeJSON)
    }
    
    self.workshops = json["workshops"].arrayValue.map { workshopJSON in
      return Workshop(from: workshopJSON)
    }
  }
}
