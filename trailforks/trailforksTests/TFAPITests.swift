//
//  TFAPITests.swift
//  trailforks
//
//  Created by Michael Pace on 1/16/23.
//

import XCTest

@testable import Trailforks

class TFAPITest: XCTestCase {
    func test_fetchReports_callResume_ensureURL() {
        let mockURLSession = MockURLSession()
        let mockURLSessionDataTask = MockURLSessionDataTask()
        mockURLSession.nextDataTask = mockURLSessionDataTask
        let subject = TrailforksAPI(urlSession: mockURLSession)

        subject.fetchReports { _ in
        }

        XCTAssertTrue(mockURLSessionDataTask.didResume)
        guard let lastURL = mockURLSession.lastURL else {
            XCTFail("No URL was called")
            return
        }
        guard let urlComponents = URLComponents(string: lastURL.absoluteString) else {
            XCTFail("URL called was invalid")
            return
        }
        XCTAssertEqual(urlComponents.host, "www.trailforks.com")
        XCTAssertEqual(urlComponents.path, "/api/1/reports")
        guard let queryItems = urlComponents.queryItems, !queryItems.isEmpty else {
            XCTFail("No query items")
            return
        }
        XCTAssertEqual(queryItems[0], URLQueryItem(name: "app_id", value: "2"))
        XCTAssertEqual(queryItems[1], URLQueryItem(name: "app_secret", value: "CiIb@mH!Gf4JzURC"))
        XCTAssertEqual(queryItems[2], URLQueryItem(name: "fields", value: "reportid,status,condition,latitude,watchmen,created,description,username"))
        XCTAssertEqual(queryItems[3], URLQueryItem(name: "filter", value: "nid::531935,type::trail"))

    }

    func test_fetchReports_200_callCompletionWithData() {
        let mockURLSession = MockURLSession()
        mockURLSession.nextResponses = [HTTPURLResponse.Happy200Request]
        mockURLSession.nextData = happyReportResponseJSON
        mockURLSession.nextDataTask = MockURLSessionDataTask()
        let subject = TrailforksAPI(urlSession: mockURLSession)
        var completionDidRun = false
        var response: [TFReport]?

        subject.fetchReports { result in
            completionDidRun = true

            switch result {
            case .success(let pageResponse): response = pageResponse
            case .failure(_): XCTFail("result shouldn't be a failure")
            }
        }

        XCTAssertTrue(completionDidRun)
        guard let response = response else {
            XCTFail("couldn't unwrap reports")
            return
        }
        XCTAssertEqual(response.count, 2)
        XCTAssertEqual(response[0].reportid, "0")
        XCTAssertEqual(response[0].status.rawValue, "4")
        XCTAssertEqual(response[0].description, "some description 1")
        XCTAssertEqual(response[0].created, "1666900320")
        XCTAssertEqual(response[0].condition.rawValue, "3")
        XCTAssertEqual(response[0].watchmen, "0")
        XCTAssertEqual(response[0].username, "owenbfoster")

        XCTAssertEqual(response[1].condition.rawValue, "4")

    }

    func test_fetchReports_400_callCompletionWithFailure() {
        let mockURLSession = MockURLSession()
        mockURLSession.nextResponses = [HTTPURLResponse.BadRequestError]
        mockURLSession.nextDataTask = MockURLSessionDataTask()
        let subject = TrailforksAPI(urlSession: mockURLSession)
        var completionDidRun = false

        subject.fetchReports { result in
            switch result {
            case .success(_): XCTFail("result shouldn't be a failure")
            case .failure(let error):
                completionDidRun = true
                XCTAssertTrue(error is TFAPIError)
            }
        }

        XCTAssertTrue(completionDidRun)
    }

    func test_fetchReports_500_callCompletionWithFailure() {
        let mockURLSession = MockURLSession()
        mockURLSession.nextResponses = [HTTPURLResponse.InternalServerError]
        mockURLSession.nextDataTask = MockURLSessionDataTask()
        let subject = TrailforksAPI(urlSession: mockURLSession)
        var completionDidRun = false

        subject.fetchReports { result in
            switch result {
            case .success(_): XCTFail("result shouldn't be a failure")
            case .failure(let error):
                completionDidRun = true
                XCTAssertTrue(error is TFAPIError)
            }
        }

        XCTAssertTrue(completionDidRun)
    }

    func test_fetchReports_error_callCompletionWithError() {
        let mockURLSession = MockURLSession()
        mockURLSession.nextError = NSError(domain: "doesn't matter", code: 666)
        mockURLSession.nextDataTask = MockURLSessionDataTask()
        let subject = TrailforksAPI(urlSession: mockURLSession)
        var completionDidRun = false

        subject.fetchReports { result in
            switch result {
            case .success(_): XCTFail("result shouldn't be a failure")
            case .failure(_): completionDidRun = true
            }
        }

        XCTAssertTrue(completionDidRun)
    }
}

extension HTTPURLResponse {
    static var Happy200Request = HTTPURLResponse(url: URL(string: "https://does.not.matter")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static var BadRequestError = HTTPURLResponse(url: URL(string: "https://does.not.matter")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
    static var InternalServerError = HTTPURLResponse(url: URL(string: "https://does.not.matter")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
}

fileprivate let happyReportResponseJSON =
    """
    {
      "data": [
        {
          "reportid": "0",
          "status": "4",
          "description": "some description 1",
          "created": "1666900320",
          "condition": "3",
          "watchmen": "0",
          "username": "owenbfoster"
        },
        {
          "reportid": "1",
          "status": "4",
          "description": "some description 2",
          "created": "1666900320",
          "condition": 4,
          "watchmen": "0",
          "username": "owenbfoster"
        }
      ]
    }
    """.data(using: .utf8)
