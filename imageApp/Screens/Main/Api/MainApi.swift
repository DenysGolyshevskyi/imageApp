//
//  MainApi.swift
//  giphyApp
//
//  Created by Denys on 30.01.2023.
//

struct PaginationModel {
    let limit: Int
    let offset: Int
}

enum MainAPI: CommonService {
    
    case getImages(query: String, pagination: PaginationModel)
    
    var method: HTTPMethod {
        switch self {
        case .getImages:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getImages:
            return "v1/gifs/search"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getImages(let query, let pagination):
            return [
                "api_key": EnvironmentVars.apiKey,
                "q": query,
                "limit": pagination.limit,
                "offset": pagination.offset,
                "rating": "q",
                "lang": "uk"
            ]
        }
    }
}
