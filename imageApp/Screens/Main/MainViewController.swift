//
//  MainViewController.swift
//  giphyApp
//
//  Created by Denys on 21.01.2023.
//

import UIKit
import RxCocoa
import RxSwift

protocol MainDisplayLogic: AnyObject {
    func displayLoadingState(isActive: Bool)
    func displayImages(viewModels: [Main.ImageViewModel])
}

class MainViewController: UIViewController, MainDisplayLogic {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var noItemsLabel: UILabel!
    var interactor: MainBusinessLogic?
    var imageViewModels: [Main.ImageViewModel]?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Private methods
    private func setupUI() {
        setupArchitecture()
        setupCollectionView()
        setupSearchBar()
        updateNoItemsLabel()
    }
    
    private func setupArchitecture() {
        let viewController = self
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Constants.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifier)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = Constants.minimumLineSpacing
        collectionView.collectionViewLayout = flowLayout
    }
    
    private func setupSearchBar() {
        searchBar.rx.text
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] searchText in
                guard let wself = self else { return }
                wself.interactor?.updateImages(searchText: searchText)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateNoItemsLabel() {
        noItemsLabel.isHidden = imageViewModels?.count ?? 0 > 0
    }
    
    // MARK: Public methods
    func displayLoadingState(isActive: Bool) {
        collectionView.isHidden = isActive
        isActive == true ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
    
    func displayImages(viewModels: [Main.ImageViewModel]) {
        if let imageViewModels = imageViewModels, imageViewModels.count != 0, viewModels.count > 0 {
            let indexPaths: [IndexPath] = Array(imageViewModels.count ... imageViewModels.count + viewModels.count - 1).map {
                IndexPath(item: $0, section: 0)
            }
            self.imageViewModels?.append(contentsOf: viewModels)
            collectionView.insertItems(at: indexPaths)
        } else {
            imageViewModels = viewModels
            collectionView.reloadData()
        }
        updateNoItemsLabel()
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let imageViewModels = imageViewModels else { return 0 }
        return imageViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let interactor = interactor,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as? ImageCollectionViewCell,
            let imageViewModel = imageViewModels?[indexPath.item]
        else {
            return UICollectionViewCell()
        }
        interactor.uploadNextImages(indexPath: indexPath)
        cell.configure(with: imageViewModel)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2 - 5, height: collectionView.bounds.width / 2 - 5)
    }
}

// MARK: Constants
extension MainViewController {
    private enum Constants {
        static let cellIdentifier: String = "ImageCollectionViewCell"
        static let minimumLineSpacing: CGFloat = 0.0001
    }
}
