//
//  MainPresenter.swift
//  giphyApp
//
//  Created by Denys on 21.01.2023.
//

import UIKit

protocol MainPresentationLogic {
    func presentLoadingState(isActive: Bool)
    func presentImages(imageViewModels: [Main.ImageViewModel])
}

class MainPresenter: MainPresentationLogic {
    
    weak var viewController: MainDisplayLogic?
    
    // MARK: Do something
    func presentLoadingState(isActive: Bool) {
        viewController?.displayLoadingState(isActive: isActive)
    }
    
    func presentImages(imageViewModels: [Main.ImageViewModel]) {
        viewController?.displayImages(viewModels: imageViewModels)
    }
}
