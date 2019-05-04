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

class TrackViewModel<T:ServiceProtocol>:TrackViewModelProtocol {
    
    var tracks:Tracks?{
        didSet {
            DispatchQueue.main.async {
                self.trackViewController?.refreshUI()
            }
        }
    }
    var errorMessage:String? {
        didSet{
            DispatchQueue.main.async {
                self.trackViewController?.showError(message:self.errorMessage!)
            }
        }
    }
    var service:T!
    weak var trackViewController:TrackViewController?
    
    init(trackViewController:TrackViewController, service:T) {
        self.trackViewController = trackViewController
        self.service = service
    }
    func searchTracks(searchText:String?) {
        guard let _searchText = searchText , _searchText.count > 0 else {
            return
        }
        service.fetchDataFrom(baseUrl:EndPoints.baseUrl.rawValue, path:EndPointsPath.search.rawValue, parameters:"media=music&entity=song&term=\(_searchText)") { [weak self] (result )  in
            // DispatchQueue.main.async {
            switch result {
            case .success(let model):
                self?.tracks = model as? Tracks
            case .failure(let error):
                
                self?.errorMessage = error.localizedDescription
                
                print(self?.errorMessage)
            }
            //}
        }
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
