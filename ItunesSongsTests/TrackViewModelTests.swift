//
//  TrackViewModelTests.swift
//  ItunesSongsTests
//
//  Copyright © 2019 MAC. All rights reserved.
//

import XCTest
@testable import ItunesSongs

class TrackViewModelTests: XCTestCase {

    var viewModel:TrackViewModel<ServiceMock<Tracks>>!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let viewController = TrackViewController()
        let serviceMock = ServiceMock<Tracks>()
       viewModel = TrackViewModel(trackViewController:viewController, service:serviceMock)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNumberOfTracks() {
        
        // when there is not tracks
        
       var numberOfTracks = viewModel.numberOfTracks()
        
        XCTAssertEqual(numberOfTracks, 0,"Nubmer of tracks are not zero")
        
        let track1 = Track(trackName:"name1", artistName:"a1")
        let track2 = Track(trackName:"name2", artistName:"a2")
        
        viewModel?.tracks = Tracks(results: [track1,track2])

         numberOfTracks = viewModel.numberOfTracks()

        XCTAssertEqual(numberOfTracks, 2,"Nubmer of tracks are not as expected")

    }
    
    func testTrackName() {
        
        let track1 = Track(trackName:"name1", artistName:"a1")
        let track2 = Track(trackName:"name2", artistName:"a2")
        
        viewModel?.tracks = Tracks(results: [track1,track2])
        
       let name =  viewModel.trackName(index: 2)
        
        XCTAssertEqual(name, nil,"Name are not equal ")
    }
    
    func testService() {
        
        
        viewModel.searchTracks(searchText: "a")

        
     XCTAssertEqual(viewModel.errorMessage!, "The operation couldn’t be completed. (ItunesSongs.NetworkError error 2.)" ,"test")
       
    }
    
    
    
}



class ServiceMock<Model:Decodable>: ServiceProtocol {
   
    typealias OUT = Model
    
    func fetchDataFrom(baseUrl: String, path: String, parameters: String, completion: @escaping (Result<Model, NetworkError>) -> Void) {
            completion(.failure(.dataParsinFailed))
    }
}
