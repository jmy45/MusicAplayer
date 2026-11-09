//
//  File.swift
//  App
//
//  Created by xianshen Jiang on 2026/10/6.
//

import Foundation

extension String {
    var asUrl: URL? {
        return URL(string: self)
    }
}
