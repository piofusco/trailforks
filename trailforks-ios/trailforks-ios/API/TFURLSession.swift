//
// Created by Michael Pace on 1/16/23.
//

import Foundation

protocol TFURLSession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> TFURLSessionDataTask
}

extension URLSession: TFURLSession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> TFURLSessionDataTask {
        dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

public protocol TFURLSessionDataTask {
    func resume()
}

extension URLSessionDataTask: TFURLSessionDataTask {}
