//
//  TrackViewModel.swift
//  ItunesSongs
//
//  Created by MAC on 01/04/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import Foundation

protocol TrackViewModelProtocol {
    func searchTracks(searchText:String?)
}

class TrackViewModel:TrackViewModelProtocol {
    
     var tracks:Tracks?{
        didSet {
            trackViewController?.refreshUI()
        }
    }
    var errorMessage:String? {
        didSet{
            trackViewController?.showError(message:self.errorMessage!)
        }
    }
    let service:Service = Service()
    weak var trackViewController:TrackViewController?
    
    init(trackViewController:TrackViewController) {
        self.trackViewController = trackViewController
    }
    func searchTracks(searchText:String?) {
         guard let _searchText = searchText , _searchText.count > 0 else {
            return
         }
        service.get(baseUrl:EndPoints.baseUrl.rawValue, path:EndPointsPath.search.rawValue, parameters:"media=music&entity=song&term=\(_searchText)", completion: { (tracks, error) in
            if let _error = error {
                self.errorMessage = _error
            }
            self.tracks = tracks
        })
    }
    
    func numberOfTracks() -> Int {
        if let _tracks = tracks?.results {
            return _tracks.count
        }
        return 0
    }
    
    func trackName(index:Int) -> String {
        if let _tracks = tracks?.results , let name = _tracks[index].trackName  {
            return name
        }
        return ""
    }
    func artistName(index:Int) -> String {
        if let _tracks = tracks?.results , let name = _tracks[index].artistName  {
            return name
        }
        return ""
    }
    
}
