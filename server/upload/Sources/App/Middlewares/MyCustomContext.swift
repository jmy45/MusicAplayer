//
//  File.swift
//  upload
//
//  Created by xianshen Jiang on 2026/10/26.
//
import Hummingbird

public protocol LocalizationRequestContext: RequestContext {
    var preferredLanguage: String { get set }
}

struct MyCustomContext: LocalizationRequestContext {
    var coreContext: CoreRequestContextStorage
    var preferredLanguage: String
    
    var services: AppServices {
        return AppServices.shared
    }
    
    init(source: Source) {
        self.coreContext = .init(source: source)
        self.preferredLanguage = "en"
    }
}
