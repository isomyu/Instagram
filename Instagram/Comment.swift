//
//  Comment.swift
//  Instagram
//
//  Created by 磯翔野 on 2019/01/31.
//  Copyright © 2019 shono.iso. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class Comment: NSObject {
    var name: String?
    var caption: String?
    var date: Date?
    var id: Int?
    
    init(snapshot: DataSnapshot) {
        
        let valueDictionary = snapshot.value as! [String: Any]
        self.id = Int(snapshot.key)
        self.name = valueDictionary["name"] as? String
        self.caption = valueDictionary["caption"] as? String
        let time = valueDictionary["time"] as? String
        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
    }
}
