//
//  Track.swift
//  ItunesSongs
//
//  Created by MAC on 01/04/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import Foundation

struct Tracks:Codable {
    
    var results:[Track]?
    
}

struct Track:Codable {
    
    var trackName:String?
    var artistName:String?
}
