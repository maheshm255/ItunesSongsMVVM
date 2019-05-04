//
//  Service.swift
//  ItunesSongs
//
//  Created by MAC on 01/04/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import Foundation


enum NetworkError:Error {
    case malformedURL(message:String)
    case errorWith(response:URLResponse?)
    case dataParsinFailed
}

typealias completionHandler<OUT:Decodable> = (Result<OUT , NetworkError>) -> Void
typealias completionHandler1<OUT:Decodable> = (OUT, Error) -> Void

protocol  ServiceProtocol {
    associatedtype OUT: Decodable
    func fetchDataFrom(baseUrl:String, path:String, parameters:String, completion:  @escaping completionHandler<OUT>)
}

class Service<Model:Decodable>:ServiceProtocol, GenericJsonDecodable {
    typealias OUT = Model
    let urlSesson = URLSession(configuration: .default)
    var dataTask:URLSessionDataTask?
    func fetchDataFrom(baseUrl: String, path: String, parameters: String, completion: @escaping (Result<Model, NetworkError>) -> Void) {
        dataTask?.cancel()
        guard var urlComponents = URLComponents(string:baseUrl + path) else {
            completion(.failure(.malformedURL(message:"URL is not correct")))
            return
        }
        urlComponents.query = "\(parameters)"
        guard let url = urlComponents.url else {
            completion(.failure(.malformedURL(message:"URL is nil")))
            return
        }
        dataTask =  urlSesson.dataTask(with:url) { (data, responce, error)  in
            guard let data = data , let _responce = responce as? HTTPURLResponse , _responce.statusCode == 200 else {
                completion(.failure(.errorWith(response: responce)))
                return
            }
            if let tracks =  self.decode(input: data) {
                completion(.success(tracks))
            }else {
                completion(.failure(.dataParsinFailed))
            }
        }
        dataTask?.resume()
    }
}


