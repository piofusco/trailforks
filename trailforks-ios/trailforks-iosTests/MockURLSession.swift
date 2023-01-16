//
//  MockURLSession.swift
//  trailforks-iosTests
//
//  Created by Michael Pace on 1/16/23.
//

import Foundation

@testable import trailforks_ios

class MockURLSession: TFURLSession {
    var lastURL: URL?

    var nextData: Data?
    var nextResponses: [HTTPURLResponse] = []
    var nextError: Error?

    var nextDataTask: TFURLSessionDataTask?

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> TFURLSessionDataTask {
        lastURL = request.url

        var nextResponse: HTTPURLResponse?
        if nextResponses.count > 0 {
            nextResponse = nextResponses.removeFirst()
        }

        completionHandler(nextData, nextResponse, nextError)

        guard let nextDataTask = nextDataTask else { fatalError("next data task not set") }
        return nextDataTask
    }
}

class MockURLSessionDataTask: TFURLSessionDataTask {
    var didResume = false
    var resumeNumberOfInvocations = 0

    func resume() {
        didResume = true
        resumeNumberOfInvocations += 1
    }
}
