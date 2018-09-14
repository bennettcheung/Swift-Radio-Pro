//
//  trackswift
//  Swift Radio
//
//  Created by Matthew Fecher on 7/2/15.
//  Copyright (c) 2015 MatthewFecher.com. All rights reserved.
//

import UIKit
import Firebase

//*****************************************************************
// Track struct
//*****************************************************************

struct Track {
	var title: String
	var artist: String
    var artworkImage: UIImage?
    var artworkLoaded = false
    let ref: DatabaseReference?
    let key: String
    
    init(title: String, artist: String) {
        self.title = title
        self.artist = artist
        self.ref = nil
        self.key = ""
    }
  
  init?(snapshot: DataSnapshot) {
    guard
      let value = snapshot.value as? [String: AnyObject],
      let artist = value["artist"] as? String,
      let title = value["title"] as? String else {
        return nil
    }
    
    self.ref = snapshot.ref
    self.key = snapshot.key
    self.title = title
    self.artist = artist

  }
  
  func toAnyObject() -> Any {
    return [
      "title": title,
      "artist": artist
    ]
  }
}
