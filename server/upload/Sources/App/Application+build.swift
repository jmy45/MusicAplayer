//===----------------------------------------------------------------------===//
//
// This source file is part of the Hummingbird server framework project
//
// Copyright (c) 2021-2021 the Hummingbird authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See hummingbird/CONTRIBUTORS.txt for the list of Hummingbird authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Hummingbird
import Logging
import NIOCore
import HummingbirdTLS
import NIOSSL // Required for TLSConfiguration
import Foundation

enum ServerError:Error{
    case nojsonfilefound
}
struct UserRequest:Decodable{
    let name: String
}
func constructResponse(dict: [String : Sendable]) -> Response{
    let data = try! JSONSerialization.data(withJSONObject:["status":200, "data":dict], options: .prettyPrinted)
    let buffer = ByteBuffer(data: data)
    return Response(
        status: .ok,
        headers: [.contentType: "application/json"],
        body: .init(byteBuffer: buffer)
    )
}

func buildApplication(args: AppArguments) throws -> some ApplicationProtocol {

    let router = Router(context: MyCustomContext.self)
    FileController().addRoutes(to: router.group("files"))
//    router.add(middleware: FileMiddleware(fileProvider: LocalFileSystem(rootFolder: "",threadPool:.singleton,logger: Logging.Logger(label:"music"))))
    router.addMiddleware {
        FileMiddleware()
        LocalizationMiddleware(
            supportedLanguages:  LocalizationService.supportedLanguages,
            defaultLanguage: "en"
        )
    }
    #if DEBUG
    router.group("test").add(middleware: LatencyMiddleware(delay: .milliseconds(500))).get("/"){ _,_ in
            return "OK"
    }
    #endif
//    guard let data = FileManager.default.contents(atPath: "public/categories.json") else{
//        throw ServerError.nojsonfilefound
//    }
//    let categories = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Sendable]]
    
    router.get("/music-categories"){ _,context -> Response in
        let musics = await context.services.localization.localize(for: context.preferredLanguage, filename: "musics")
        let categories = await context.services.localization.localize(for: context.preferredLanguage, filename: "categories")
        return constructResponse(dict: [
            "categories":categories,
            "populars":musics,
            "specials":musics
        ])
    }
    
//    router.get("/orders"){ _,context -> Response in
//        guard let orders = FileManager.default.contents(atPath: "public/orders.json") else{
//            throw ServerError.nojsonfilefound
//        }
//        let rawdata = try? JSONSerialization.jsonObject(with: orders, options: .mutableContainers) as? [[String: Sendable]]
//        return constructResponse(dict: rawdata!)
//    }
//    router.post("orders/:musicId") { request,context in
//        guard let Id = context.parameters.get("musicId") else {
//            throw HTTPError(.badRequest, message: "Missing music ID in path")
//        }
//        let user = try await request.decode(as: UserRequest.self, context: context)
//        guard let music = musics?.filter({ $0["id"] as! String == Id })[0] else {
//            throw HTTPError(.notFound, message: "music with ID \(Id) not found")
//        }
//        let order = [
//            "id":Id,
//            "name":user.name,
//            "music":music
//        ]
//        return constructResponse(data: order)
//    }
//    router.get("dishes/:categoryId") { _, context in
//        guard let Id = context.parameters.get("categoryId") else {
//            throw HTTPError(.badRequest, message: "Missing category ID in path")
//        }
//        guard let matched = musics?.filter({ $0["category"] as! String == Id }) else {
//            throw HTTPError(.notFound, message: "category with ID \(Id) not found")
//        }
//        return constructResponse(data: matched)
//    }
                
//    // 1. Load your certificate chain and private key files
//    // (Replace with paths to your actual .crt/.pem and .key files)
//    let certificateChain = try NIOSSLSecureBytes.certificateChain(fromFile: "/path/to/certificate.crt")
//    let privateKey = try NIOSSLSecureBytes.privateKey(fromFile: "/path/to/private.key")
//
//    // 2. Create the TLS Server Configuration
//    let tlsConfiguration = TLSConfiguration.makeServerConfiguration(
//        certificateChain: certificateChain,
//        privateKey: privateKey
//    )
    

    let certificateChain = try! NIOSSLCertificate.fromPEMFile("localhost.crt")
    let privateKey = try! NIOSSLPrivateKey(file: "localhost.key", format: .pem)
    let tlsConfiguration = TLSConfiguration.makeServerConfiguration(
        certificateChain: certificateChain.map { .certificate($0) },
        privateKey: .privateKey(privateKey)
    )

    // 3. Initialize Application with the TLS server protocol
    return Application(
        router: router,
        server: try! .tls(.http1(), tlsConfiguration: tlsConfiguration),
        configuration: .init(address: .hostname(args.hostname, port: args.port))
    )
}
