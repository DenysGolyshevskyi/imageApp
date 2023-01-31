//
//  NetworkError.swift
//  giphyApp
//
//  Created by Denys on 30.01.2023.
//

import Foundation

public indirect enum NetworkError: LocalizedError {
    case nsUrlErrorDomain(String, Int)
    case noData
    case serviceResponseData(String, Int)
    case anotherError(String, Error)
    case wrongStatusCode(String, Int, NetworkError?)
    case badUrl
    case processableError(ErrorModel)
    case noInternet

    public var errorDescription: String? {
        switch self {
        case .nsUrlErrorDomain(let descr, _):
            return descr
        case .serviceResponseData(let descr, _):
            return descr
        case .noData:
            // TODO: Move to localizebles
            return "network_error_no_data"
        case .anotherError(let descr, _):
            return descr
        case .wrongStatusCode(let descr, _, let internalError):
            return internalError?.localizedDescription ?? descr
        case .badUrl:
            // TODO: Move to localizebles
            return "network_error_bad_url"
        case .processableError(let errorModel):
            return errorModel.message
        case .noInternet:
            // TODO: Move to localizebles
            return "network_no_internet"
        }
    }
}

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.nsUrlErrorDomain, .nsUrlErrorDomain):
            return true
        case (.noData, .noData):
            return true
        case (.serviceResponseData, .serviceResponseData):
            return true
        case (.anotherError, .anotherError):
            return true
        case (.wrongStatusCode, .wrongStatusCode):
            return true
        case (.processableError, .processableError):
            return true
        case (.noInternet, .noInternet):
            return true
        default:
            return false
        }
    }
}

public struct ErrorModel: Decodable {
    let processCode: Int
    let message: String?
}
