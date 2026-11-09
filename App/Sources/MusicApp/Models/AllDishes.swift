//
//  File.swift
//  App
//
//  Created by xianshen Jiang on 2026/10/10.
//

import Foundation

struct AllDishes: Decodable {
    let categories: [DishCategory]?
    let populars: [Music]?
    let specials: [Music]?
}

