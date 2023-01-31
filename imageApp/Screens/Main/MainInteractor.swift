//
//  MainInteractor.swift
//  giphyApp
//
//  Created by Denys on 21.01.2023.
//

import UIKit

protocol MainBusinessLogic {
    func updateImages(searchText: String?)
    func uploadNextImages(indexPath: IndexPath)
    func processResponse(response: Main.ResponseModel?)
}

protocol MainDataStore {
    var imageModels: [Main.ImageViewModel] {get set}
    var offset: Int {get set}
    var limit: Int {get set}
    var searchText: String {get set}
}

class MainInteractor: MainBusinessLogic, MainDataStore {
    
    var presenter: MainPresentationLogic?
    var worker: MainWorker?
    var imageModels: [Main.ImageViewModel] = []
    var offset: Int = 0
    var limit: Int = 15
    var searchText: String = ""
    private var total: Int?
    private var isFetching: Bool = false
    
    
    // MARK: Public Methods
    func updateImages(searchText: String?) {
        self.searchText = searchText ?? ""
        imageModels = []
        total = nil
        offset = 0
        isFetching = false
        presenter?.presentImages(imageViewModels: imageModels)
        if let searchText = searchText, !searchText.isEmpty {
            fetchNextImages()
        } else {
            presenter?.presentImages(imageViewModels: imageModels)
        }
    }
    
    func uploadNextImages(indexPath: IndexPath) {
        if indexPath.item == imageModels.count - 3 { fetchNextImages() }
    }
    
    func processResponse(response: Main.ResponseModel?) {
        guard let response = response else { return }
        let fetchedImageViewModels = response.data.map {
            Main.ImageViewModel(imageURL: $0.images.original.url, imageName: $0.id)
        }
        imageModels.append(contentsOf: fetchedImageViewModels)
        total = response.pagination.totalCount
        isFetching = false
        presenter?.presentLoadingState(isActive: false)
        presenter?.presentImages(imageViewModels: fetchedImageViewModels)
        offset = response.pagination.count + response.pagination.offset
    }
    
    // MARK: Private Methods
    private func fetchNextImages() {
        if isFetching || (total ?? Int.max <= imageModels.count) { return }
        isFetching = true
        presenter?.presentLoadingState(isActive: true)
        
        worker = MainWorker(interactor: self)
        let request = Main.Request(searchText: searchText, pagination: PaginationModel(limit: limit, offset: offset))
        worker?.getDataFromGiphy(request: request)
    }
}
