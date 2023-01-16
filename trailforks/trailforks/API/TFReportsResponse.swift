//
//  TFReportsResponse.swift
//  trailforks
//
//  Created by Michael Pace on 1/16/23.
//

import Foundation

struct TFReportsResponse: Decodable {
    let data: [TFReport]
}

enum TFReportsStatus: String, Decodable, CustomStringConvertible {
    case clear = "1" // Green
    case minorIssue = "2" // Yellow
    case significantIssue = "3" // Amber
    case closed = "4"

    var description: String {
        switch self {
            case .clear: return "Clear"
            case .minorIssue: return "Minor Issue"
            case .significantIssue: return "Significant Issue"
            case .closed: return "Closed"
        }
    }
}

struct TFReport: Decodable {
    let reportid: String
    let status: TFReportsStatus
    let description: String
    let created: String
    let condition: TFTrailConditions
    let watchmen: String
    let username: String
}
