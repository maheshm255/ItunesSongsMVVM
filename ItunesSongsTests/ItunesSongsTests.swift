//
//  ItunesSongsTests.swift
//  ItunesSongsTests
//
//  Created by MAC on 01/04/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import XCTest
@testable import ItunesSongs

class ItunesSongsTests: XCTestCase {
    
    var trackViewModel:TrackViewModel?
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        trackViewModel = TrackViewModel(trackViewController: TrackViewController())
    }
    
    func testNumberOfTracks() {
        let track1 = Track(trackName:"name1", artistName:"a1")
        let track2 = Track(trackName:"name2", artistName:"a2")

        trackViewModel?.tracks = [track1,track2]
        
        let numberOfTracks =  trackViewModel?.numberOfTracks()
        
        XCTAssertEqual(numberOfTracks,2, "Number of tracks is one")
    }
    
}
