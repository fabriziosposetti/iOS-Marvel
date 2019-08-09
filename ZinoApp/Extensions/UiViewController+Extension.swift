//
//  UiViewController+Extension.swift
//  ZinoApp
//
//  Created by Fabrizio Sposetti on 02/08/2019.
//  Copyright © 2019 Fabrizio Sposetti. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher


extension UIViewController {
    
    
    func showToast(message : String, width: CGFloat, backgroundColor: UIColor) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2,
                                               y: self.view.frame.size.height-100,
                                               width: width, height: 40))
        toastLabel.center = self.view.center
        toastLabel.backgroundColor = backgroundColor
        toastLabel.textColor = UIColor.black
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 14.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 6.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = .blue
        self.view.addSubview(activityIndicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func setImageFrom(_ url: String, _ imageView: UIImageView) {
        let urlResource = URL(string: url)!
        let processor = DownsamplingImageProcessor(size: self.view.bounds.size)
            >> RoundCornerImageProcessor(cornerRadius: 20)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: urlResource,
            placeholder: UIImage(named: "avatar-placeholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
        ]) {
            result in
            switch result {
            case .success:
                break
            case .failure:
                break
            }
        }
        
    }
    
}
