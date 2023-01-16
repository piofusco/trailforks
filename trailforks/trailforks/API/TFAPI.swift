//
//  TrailforksAPI.swift
//  trailforks
//
//  Created by Michael Pace on 1/16/23.
//

import Foundation


protocol TFAPI {
    func fetchReports(completion: @escaping (Result<[TFReport], Error>) -> Void)
}

class TrailforksAPI: TFAPI {
    private static let BASE_URL = "https://www.trailforks.com/api/1"

    private let urlSession: TFURLSession
    private let decoder = JSONDecoder()

    init(urlSession: TFURLSession) {
        self.urlSession = urlSession
    }

    func fetchReports(completion: @escaping (Result<[TFReport], Error>) -> ()) {
        guard let url = URL(string: TrailforksAPI.BASE_URL + "/reports") else { return }

        urlSession.dataTask(with: URLRequest(url: url)) { [weak self] data, response, networkError in
            guard let self = self else { return }

            if let error = networkError { completion(Result.failure(error)) }

            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                guard let data = data else { return }

                var response: TFReportsResponse?
                do {
                    response = try self.decoder.decode(TFReportsResponse.self, from: data)
                } catch DecodingError.keyNotFound(_, let context),
                    DecodingError.valueNotFound(_, let context),
                    DecodingError.typeMismatch(_, let context),
                    DecodingError.dataCorrupted(let context) {
                    print(context.debugDescription)
                } catch {
                    completion(Result.failure(error))
                    return
                }
                if let responseToReturn = response {
                    completion(Result.success(responseToReturn.data))
                }
            } else if response.statusCode == 400 {
                completion(Result.failure(TFAPIError.badRequest))
            } else if response.statusCode == 500 {
                completion(Result.failure(TFAPIError.internalServerError))
            }
        }.resume()
    }
}
