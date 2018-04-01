//
//  Service.swift
//  ItunesSongs
//
//  Created by MAC on 01/04/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import Foundation


typealias jsonDictionery = [String: Any]
typealias completionHandler = ([Track]?,String?) -> ()

protocol  ServiceProtocol {
    func get(baseUrl:String, path:String, parameters:String,completion: @escaping completionHandler)
}


class Service:ServiceProtocol {

    let urlSesson = URLSession(configuration: .default)
    var dataTask:URLSessionDataTask?
    var errorMessage:String?
    var tracks:[Track] = []
    
    func get(baseUrl: String, path: String, parameters: String, completion:@escaping completionHandler) {
        dataTask?.cancel()
        guard var urlComponents = URLComponents(string:baseUrl + path) else {
            errorMessage = "URL is not correct"
            return
        }
        urlComponents.query = "\(parameters)"
        guard let url = urlComponents.url else {
            errorMessage = "URL is nil"
            return
        }
        dataTask =  urlSesson.dataTask(with:url) { (data, responce, error)  in
            if let _error = error {
                self.errorMessage = "responce error \(_error.localizedDescription)"
            }else if let _data = data , let _responce = responce as? HTTPURLResponse , _responce.statusCode == 200 {
                self.parseTrackData(data:_data)
                DispatchQueue.main.async {
                    completion(self.tracks, self.errorMessage)
                }
            }
        }
       dataTask?.resume()
    }
    
    fileprivate func parseTrackData(data:Data) {
        self.errorMessage = nil
        self.tracks.removeAll()
        var responce:jsonDictionery?
        do {
            responce = try JSONSerialization.jsonObject(with:data, options:.allowFragments) as? jsonDictionery
        }catch {
            self.errorMessage = "responce parsing failed with error \(error.localizedDescription)"
        }
        guard let array = responce!["results"] as? [Any] else {
            self.errorMessage = "responce is empty"
            return
        }
        if array.count == 0 {
            self.errorMessage = "No Result"
        }
        for trackDict in array {
            if let _trackDict = trackDict as? jsonDictionery {
                let name = _trackDict["trackName"] as? String
                let artist = _trackDict["artistName"] as? String
                let track = Track(trackName:name, artistName:artist)
                tracks.append(track)
            }
        }
    }
}


