//
//  Event.swift
//  Fetch Rewards Coding Exercise
//
//  Created by Abraham Estrada on 5/19/21.
//

import Foundation
import SwiftyJSON

struct Event {
    var id: Int
    var name: String
    var date: String
    var location: String
    var imageURL: String
    var isFavorited: Bool {
        let favoritedEvents = UserDefaults.standard.array(forKey: FAVORITEDEVENTSKEY) as? [Int] ?? [Int]()
        return favoritedEvents.contains(self.id)
    }
    
    init(data: JSON, index: Int) {
        id = data["events"][index]["id"].intValue
        name = data["events"][index]["venue"]["name"].stringValue
        date = Event.getDate(data["events"][index]["datetime_utc"].stringValue)
        location = data["events"][index]["venue"]["display_location"].stringValue
        imageURL = data["events"][index]["performers"][0]["image"].stringValue
    }
    
    static func getDate(_ string: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddEHH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let utcDate = dateFormatter.date(from: string)
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy, h:mm a"
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.string(from: utcDate!)
        return date
    }
}
