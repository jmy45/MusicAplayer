//
//  File.swift
//  App
//
//  Created by xianshen Jiang on 2026/10/9.
//

import Foundation

struct ApiResponse<T: Decodable>: Decodable {
    let status: Int
    let message: String?
    let data: T?
    let error: String?
}
