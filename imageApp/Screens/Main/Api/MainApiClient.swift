//
//  MainApiClient.swift
//  giphyApp
//
//  Created by Denys on 30.01.2023.
//

import Foundation
import Alamofire

class MainAPIClient: ApiClient<MainAPI> {
    
    func getImages(query: String, pagination: PaginationModel) -> DataRequest {
        return request(.getImages(query: query, pagination: pagination))
    }
}

