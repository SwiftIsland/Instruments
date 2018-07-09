import Foundation
import SwiftyJSON

struct JSONParser {
  var rawData: Data? {
    guard let filePath = Bundle.main.path(forResource: "data",
                                          ofType: "json",
                                          inDirectory: nil,
                                          forLocalization: nil)
      else { return nil }
    
    let url = URL(fileURLWithPath: filePath)
    return try? Data(contentsOf: url)
  }
  
  func load(_ callback: () -> Void) {
    guard let data = rawData, let json = try? JSON(data: data) else { return }
    
    var conferences = [Conference]()
    for confJSON in json.arrayValue {
      conferences.append(Conference(from: confJSON))
    }
    
    print(conferences.count)
    
    callback()
  }
  
  func load2(_ callback: () -> Void) {
    guard let data = rawData else { return }
    
    let decoder = JSONDecoder()
    guard let conferences = try? decoder.decode([Conference].self, from: data)
      else { return }
    
    print(conferences.count)
    
    callback()
  }
}
