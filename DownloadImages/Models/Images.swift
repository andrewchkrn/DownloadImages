//
//  Images.swift
//  DownloadImages
//
//  Created by Andrew Trach on 21.03.2021.
//

import Foundation


struct DataModel {

    var urls: Results?
    
    let alt_description: String
    
    init?(dict: [String: Any]) {
        guard let alt_description = dict["alt_description"] as? String,
              let results = dict["urls"] as? [String: Any]
        else {
            return nil
        }

       
        self.urls =  Results(dict: results)
        self.alt_description = alt_description
       
    }
}

struct Results {

    var small: String
    var full: String
  
    init?(dict: [String: Any]) {
        guard  let small = dict["small"] as? String,
               let full = dict["full"] as? String else {
            return nil
        }
        
        self.full = full
        self.small = small
    }
}
