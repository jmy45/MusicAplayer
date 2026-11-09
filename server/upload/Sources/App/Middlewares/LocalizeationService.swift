//
//  File.swift
//  upload
//
//  Created by xianshen Jiang on 2026/10/26.
//
import Foundation

actor LocalizationService {
    
    private var translations: [String:[String: [[String: Sendable]]]] = [:]
    static let supportedLanguages = ["en","zh"]
    
    init() {
        translations = LocalizationService.loadTranslations()
    }
    
    private static func loadTranslations() -> [String:[String: [[String: Sendable]]]]  {
        
        var translations: [String:[String: [[String: Sendable]]]] = [:]

        for lang in supportedLanguages {
            
            translations[lang] = [:]
            for filename in ["categories","musics","orders"] {
                let filePath = "public/Localization/\(lang)/\(filename).json"
                
                guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
                      let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Sendable]] else {
                    print("⚠️ Failed to load localization file for: \(lang)_\(filename)")
                    continue
                }
                translations[lang]![filename] = json
            }
        }
        return translations
    }
    
    func localize(for lang: String, filename: String) -> [[String: Sendable]]{
        return translations[lang]?[filename] ?? translations["en"]?[filename] ?? []
    }
    

//    func localize(key: String, for language: String) -> String {
//        return translations[language]?[key] ?? translations["en"]?[key] ?? key
//    }
}

struct AppServices : Sendable {
    
    let localization: LocalizationService
    static let shared = AppServices(localization: LocalizationService())
    
}
