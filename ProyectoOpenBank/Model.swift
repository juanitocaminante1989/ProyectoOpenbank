//
//  Model.swift
//  ProyectoOpenBank
//
//  Created by Juan Jimenez de Muñana Rivas on 18/05/2020.
//  Copyright © 2020 Juan Jimenez de Muñana Rivas. All rights reserved.
//

import Foundation

public struct dataVariables {
    let api = "http://gateway.marvel.com/v1/public/characters"
    let apikey = "42b76ed9bd8870d4935b14099fa3b290"
    let hash = "be5138cc116eec7b09ed4cd4c5285a38"
}


public struct response: Codable {
       let data : responseData
}

public struct responseData: Codable {
    var count: Int = 0
    var limit: Int = 0
    var offset: Int = 0
    var results: [CharactersRaw]
}

public struct CharactersRaw: Codable {
    var id: Int = 0
    var name: String = ""
    var thumbnail: thumbnail
    var description: String = ""
}

public struct thumbnail: Codable {
    var path: String = ""
    var extensin: String = ""
    enum CodingKeys: String, CodingKey {
        case path = "path"
        case extensin = "extension"
    }
}

public class Character{
    var id: Int = 0
    var name: String = ""
    var path: String = ""
}

class DetailCharacter {
    var id: Int = 0
    var name: String = ""
    var path: String = ""
    var description: String = ""
}
