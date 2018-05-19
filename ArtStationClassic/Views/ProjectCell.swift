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
    
    @IBOutlet weak var iconStack: UIStackView!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var videoIcon: UIImageView!
    @IBOutlet weak var model3dIcon: UIImageView!
    @IBOutlet weak var marmosetIcon: UIImageView!
    @IBOutlet weak var panoIcon: UIImageView!
    
    @IBOutlet var icons: [UIImageView]!
    
    var projectViewModel: ProjectViewModel!
    
    private struct Consts {
        static let placeholerImage = "small_square-placehholder"
    }
    
    private func configureIcons(with options: IconsOptions) {
        imageIcon.isHidden = !options.contains(.image)
        videoIcon.isHidden = !options.contains(.video)
        model3dIcon.isHidden = !options.contains(.model3d)
        marmosetIcon.isHidden = !options.contains(.marmoset)
        panoIcon.isHidden = !options.contains(.pano)

    }
    
    func configure(with projectViewModel: ProjectViewModel, showAdditionaInfo: Bool) {
        self.projectViewModel = projectViewModel
        
        if showAdditionaInfo {
            configureIcons(with: projectViewModel.iconOptions)
        }
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
    
    override func awakeFromNib() {
        icons.forEach{ $0.isHidden = true}
    }
    
    override func prepareForReuse() {
        imageView.image = UIImage(named: Consts.placeholerImage)
        activityIndicator.isHidden = false
        icons.forEach{ $0.isHidden = true}
    }
}
