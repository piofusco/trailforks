//
// Created by Michael Pace on 1/16/23.
//

import Foundation

enum TFTrailConditions: String, Decodable, CustomStringConvertible {
    case unknown = "0"
    case snowPacked = "1"
    case prevalentMud = "2"
    case wet = "3"
    case variable = "4"
    case dry = "5"
    case veryDry = "6"
    case snowCovered = "7"
    case freezeThawCycle = "8"
    case icy = "9"
    case snowGroomed = "10"
    case snowCoverInadequate = "12"
    case ideal = "11"

    var description: String {
        switch self {
        case .unknown: return "Unknown"
        case .snowGroomed: return "Snow Groomed"
        case .snowPacked: return "Snow Packed"
        case .snowCovered: return "Snow Covered"
        case .snowCoverInadequate: return "Snow Cover Inadequate"
        case .freezeThawCycle: return "Freeze Thaw Cycle"
        case .icy: return "Icy"
        case .prevalentMud: return "Prevalent Mud"
        case .wet: return "Wet"
        case .variable: return "Variable"
        case .ideal: return "Ideal"
        case .dry: return "Dry"
        case .veryDry: return "Very Dry"
        }
    }

    init(from decoder: Decoder) throws {
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            switch string {
            case "1": self = .snowPacked
            case "2": self = .prevalentMud
            case "3": self = .wet
            case "4": self = .variable
            case "5": self = .dry
            case "6": self = .veryDry
            case "7": self = .snowCovered
            case "8": self = .freezeThawCycle
            case "9": self = .icy
            case "10": self = .snowGroomed
            case "12": self = .snowCoverInadequate
            case "11": self = .ideal
            default: self = .unknown
            }
            return
        }

        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            switch int {
            case 1: self = .snowPacked
            case 2: self = .prevalentMud
            case 3: self = .wet
            case 4: self = .variable
            case 5: self = .dry
            case 6: self = .veryDry
            case 7: self = .snowCovered
            case 8: self = .freezeThawCycle
            case 9: self = .icy
            case 10: self = .snowGroomed
            case 12: self = .snowCoverInadequate
            case 11: self = .ideal
            default: self = .unknown
            }
            return
        }

        self = .unknown
    }
}

extension TFTrailConditions {
    enum Error: Swift.Error {
        case couldNotFindStringOrInt
    }
}
