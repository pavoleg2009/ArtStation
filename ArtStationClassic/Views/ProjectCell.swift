//
//  ProjectCell.swift
//  ArtStationClassic
//
//  Created by Oleg Pavlichenkov on 18/05/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import UIKit

class ProjectCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var projectViewModel: ProjectViewModel!
    
    private struct Consts {
        static let placeholerImage = "small_square-placehholder"
    }
    
    func configure(with projectViewModel: ProjectViewModel) {
        self.projectViewModel = projectViewModel

//        imageView.image = UIImage(contentsOfFile: projectViewModel.imageLink.absoluteString)
//        print(projectViewModel.imageLink.absoluteString)
        
//        activityIndicator.stopAnimating()
//        activityIndicator.isHidden = true
    }
    
    func updateImageViewWithImage(_ image: UIImage?) {
        if let image = image {
            imageView.image = image
            
//            imageView.alpha = 0
//            UIView.animate(withDuration: 0.3, animations: {
//                self.imageView.alpha = 1.0
//                self.activityIndicator.alpha = 0
//            }, completion: {
//                _ in
//                self.activityIndicator.stopAnimating()
//            })
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        } else {
            imageView.image = nil
//            imageView.alpha = 0
//            activityIndicator.alpha = 1.0
            imageView.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
    }
    
    override func prepareForReuse() {
        imageView.image = UIImage(named: Consts.placeholerImage)
    }
}
