//
//  File.swift
//  App
//
//  Created by xianshen Jiang on 2026/10/7.
//

import Foundation

struct Music: Decodable {
    let id, name, description, image, album: String?
    let playurl, album_cover_image:String
    let calories: Int?
    
    var formattedCalories: String {
        return "\(calories ?? 0) calories"
    }
}
