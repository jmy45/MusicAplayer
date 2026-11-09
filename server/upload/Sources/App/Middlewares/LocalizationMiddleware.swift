//
//  File.swift
//  upload
//
//  Created by xianshen Jiang on 2026/10/26.
//

import Hummingbird

public struct LocalizationMiddleware<Context: LocalizationRequestContext>: RouterMiddleware {
    public let supportedLanguages: [String]
    public let defaultLanguage: String
    
    public init(supportedLanguages: [String], defaultLanguage: String = "en") {
        self.supportedLanguages = supportedLanguages
        self.defaultLanguage = defaultLanguage
    }
    
    public func handle(
        _ request: Request,
        context: Context,
        next: (Request, Context) async throws -> Response
    ) async throws -> Response {
        // 1. Mutate a copy of the context to set the localized value
        var context = context
        context.preferredLanguage = determineLanguage(for: request)
        
        // 2. Pass the updated context down to the next middleware or route handler
        var response = try await next(request, context)
        
        // 3. Inject the explicit content language back to the client response
        response.headers[.contentLanguage] = context.preferredLanguage
        return response
    }
    
    // MARK: - Negotiation Helpers
    
    private func determineLanguage(for request: Request) -> String {
        guard let acceptLanguageHeader = request.headers[.acceptLanguage] else {
            return defaultLanguage
        }
        
        let clientPreferences = parseAcceptLanguage(acceptLanguageHeader)
        
        for clientLang in clientPreferences {
            if supportedLanguages.contains(clientLang) {
                return clientLang
            }
            
            // Fallback strategy: match base tag if regional tag misses (e.g. "en-GB" -> "en")
            let baseLang = String(clientLang.split(separator: "-").first ?? "")
            if supportedLanguages.contains(baseLang) {
                return baseLang
            }
        }
        return defaultLanguage
    }
    
    private func parseAcceptLanguage(_ headerValue: String) -> [String] {
        let components = headerValue.split(separator: ",")
        var preferences: [(code: String, priority: Double)] = []
        
        for component in components {
            let parts = component.split(separator: ";")
            guard let lang = parts.first?.trimmingCharacters(in: .whitespaces) else { continue }
            
            var qValue = 1.0
            if parts.count > 1, let qPart = parts.last?.trimmingCharacters(in: .whitespaces), qPart.hasPrefix("q=") {
                qValue = Double(qPart.dropFirst(2)) ?? 1.0
            }
            preferences.append((code: lang, priority: qValue))
        }
        return preferences.sorted { $0.priority > $1.priority }.map { $0.code }
    }
}
