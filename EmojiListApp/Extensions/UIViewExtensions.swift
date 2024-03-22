//
//  UIViewExtensions.swift
//  EmojiListApp
//
//  Created by Mehmet Ali ÇELEBİ on 22.03.2024.
//

import UIKit

extension UIView {
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.frame.size.width / 2 - 150, y: self.frame.size.height / 2, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 12)
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.addSubview(toastLabel)
        UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 1.0
        }, completion: {(isCompleted) in
            UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()

            })
        })
    }
}
