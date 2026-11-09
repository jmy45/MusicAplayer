//
//  File.swift
//  upload
//
//  Created by xianshen Jiang on 2026/10/31.
//

import Hummingbird

struct LatencyMiddleware<Context: RequestContext>: RouterMiddleware {
    
    let delay: Duration
    func handle(_ request: Request, context: Context, next: (Request, Context) async throws -> Response) async throws -> Response {
        try await Task.sleep(for: delay)
        return try await next(request, context)
    }
}
