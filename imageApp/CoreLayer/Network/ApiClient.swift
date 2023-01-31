//
//  ApiClient.swift
//  giphyApp
//
//  Created by Denys on 30.01.2023.
//

import Alamofire

open class ApiClient<T: CommonService> {
    
    func request(_ service: T) -> DataRequest {
        return AF.request(service)
    }
}
