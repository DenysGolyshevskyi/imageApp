//
//  MainWorker.swift
//  giphyApp
//
//  Created by Denys on 21.01.2023.
//

import UIKit
import Alamofire

class MainWorker {
    
    let interactor: MainBusinessLogic
    let apiClient: MainAPIClient
    
    init(interactor: MainBusinessLogic) {
        self.interactor = interactor
        self.apiClient = MainAPIClient()
    }
    
    func getDataFromGiphy(request: Main.Request) {
        apiClient.getImages(query: request.searchText, pagination: request.pagination)
            .responseData(completionHandler: { [weak self] response in
                switch response.result {
                case .success(let jsonData):
                    guard let responseModel = try? JSONDecoder().decode(Main.ResponseModel.self, from: jsonData) else { return }
                    self?.interactor.processResponse(response: responseModel)
                case .failure:
                    self?.interactor.processResponse(response: nil)
                }
            })
    }
}
