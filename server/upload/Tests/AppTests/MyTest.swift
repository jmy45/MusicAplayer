//
//  Test.swift
//  upload
//
//  Created by xianshen Jiang on 2026/10/30.
//
import Hummingbird
import HummingbirdTesting
import Testing
import Foundation

@testable import App

//@Suite("Performance Test")
struct Test {
    struct TestArguments: AppArguments {
        var hostname: String { "127.0.0.1" }
        var port: Int { 8443 }
    }
    // -------------------------------------------------------------
    // Test1:(Maximum Parallel Request Test)
    // -------------------------------------------------------------
    @Test("Maximum Parallel Request Test")
    func MaximumParallelRequestsTest() async throws {

        let app = try buildApplication(args: TestArguments())
                
                try await app.test(.live) { client in
                    let concurrentCount = 10000
                    
                    try await withThrowingTaskGroup(of: Void.self) { group in
                        for _ in 0..<concurrentCount {
                            group.addTask {
                                let response = try await client.execute(
                                    uri: "/music-categories",
                                    method: .get,
                                    //headers: [.connection: "close"]
                                )
                                #expect(response.status == .ok)
                            }
                        }
                        try await group.waitForAll()
                    }
                }
    }
    // -------------------------------------------------------------
    // Test2: (Delay / Latency Test)
    // -------------------------------------------------------------
    @Test("Delay / Latency Test")
    func testLatencyAndNonBlocking() async throws {
        let app = try buildApplication(args: TestArguments())
        
        try await app.test(.live) { client in
            let port = client.port!
            func timed(_ path: String) async throws -> Duration {
                let clock = ContinuousClock()
                let start = clock.now
                let (_, response) = try await URLSession.shared.data(from: URL(string: "http://localhost:\(port)\(path)")!)
                #expect((response as? HTTPURLResponse)?.statusCode == 200)
                return clock.now - start
            }

            async let quick = timed("/music-categories")
            async let slow = timed("/test")
            let (q, s) = try await (quick, slow)
            print("quick:", q, "slow:", s)
            #expect(s >= .milliseconds(500))
            #expect(q < s / 2)

//            let clock = ContinuousClock()
//            async let quickTask: Duration = {
//                let start = clock.now
//                //dish-categories
//                let response = try await client.execute(uri: "/test2", method: .get)
//                #expect(response.status == .ok)
//                return clock.now - start
//            }()
//            
//            async let slowTask: Duration = {
//                let start = clock.now
//                let response = try await client.execute(uri: "/test", method: .get)
//                #expect(response.status == .ok)
//                return clock.now - start
//            }()
//
//           let quickDuration = try await quickTask
//           let slowDuration = try await slowTask
//           
//           print("health:\(quickDuration)")
//           print("delay:\(slowDuration)")
//           
//           #expect(quickDuration < .milliseconds(80), "too slow")
//           #expect(slowDuration >= .milliseconds(500), "delay not work")
            
//            async let delayedResponse = client.execute(uri: "/test/", method: .get)
//            let delayed = try await delayedResponse
//            #expect(delayed.status == .ok)
//            #expect(String(buffer: delayed.body) == "OK")
        }
    }
}
