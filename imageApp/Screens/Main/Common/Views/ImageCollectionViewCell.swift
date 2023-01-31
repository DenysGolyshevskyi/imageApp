//
//  ImageCollectionViewCell.swift
//  giphyApp
//
//  Created by Denys on 21.01.2023.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var viewModel: Main.ImageViewModel?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialSetup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewModel = nil
    }
    
    // MARK: - Private Methods
    private func initialSetup() {
        // TODO: - Add and set image "noImage"
        //imageView.image = .noImage
        activityIndicator.startAnimating()
    }
    
    // MARK: - Configuration
    func configure(with viewModel: Main.ImageViewModel) {
        self.viewModel = viewModel
        
        if let imageURLString = viewModel.imageURL, let imageURL = URL(string: imageURLString) {
            imageView.loadImage(form: imageURL, with: activityIndicator)
        }
    }
}
