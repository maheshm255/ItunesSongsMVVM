//
//  GenericJsonDecoder.swift
//  ItunesSongs
//
//  Copyright © 2019 MAC. All rights reserved.
//

import Foundation

protocol GenericJsonDecodable {
    associatedtype OUT:Decodable
    func decode(input:Data) -> OUT?
}

extension GenericJsonDecodable {
    func decode(input:Data) -> OUT? {
        do {
           return  try JSONDecoder().decode(OUT.self, from: input)
        }catch {
            return nil
        }
    }
}
