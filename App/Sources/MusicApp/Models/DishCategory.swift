//
//  DishCategory.swift
//  MusicPlayer
//
//  Created by xianshen Jiang on 2026/10/4.
//

import Foundation

struct DishCategory: Decodable {
    let id, name, image: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "title"
        case image
    }
}
