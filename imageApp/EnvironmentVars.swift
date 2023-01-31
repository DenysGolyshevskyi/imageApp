//
//  EnvironmentVars.swift
//  giphyApp
//
//  Created by Denys on 31.01.2023.
//

import Foundation

private struct EnvironmentKeys {
    static let apiBaseURL = "ApiBaseURL"
    static let apiKey = "ApiKey"
}

struct EnvironmentVars {
    
    static let baseApiHost: String = {
        let value = Bundle.main.infoDictionary?[EnvironmentKeys.apiBaseURL] as? String ?? ""
        return value
    }()
    
    static let apiHost: String = {
        return "https://\(baseApiHost)/"
    }()
    
    static let apiKey: String = {
        let value = Bundle.main.infoDictionary?[EnvironmentKeys.apiKey] as? String ?? ""
        return value
    }()
}
