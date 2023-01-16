//
// Created by Michael Pace on 1/16/23.
//

import Foundation

enum TFAPIError: Error {
    case badRequest
    case internalServerError
    case internalDeviceError
    case unexpected(code: Int)
}

extension TFAPIError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .badRequest: return "Bad Request."
        case .internalServerError: return "Internal Server Error."
        case .internalDeviceError: return "Internal Device Error."
        case .unexpected(_): return "An unexpected error occurred."
        }
    }
}

extension TFAPIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badRequest:
            return NSLocalizedString(
                "Description of bad request",
                comment: "Bad Request."
            )
        case .internalServerError:
            return NSLocalizedString(
                "Description of internal server error",
                comment: "Internal Server Error."
            )
        case .internalDeviceError:
            return NSLocalizedString(
                "Description of internal device error",
                comment: "Internal Device Error."
            )
        case .unexpected(_):
            return NSLocalizedString(
                "Description of unexpected",
                comment: "An unexpected error occurred."
            )
        }
    }
}
