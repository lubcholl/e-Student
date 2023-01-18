//
//  Extensions.swift
//  e-Student
//
//  Created by Lyubomir on 4.07.22.
//

import Foundation
import UIKit

extension UIViewController {
    public func addSwipeBackGesture() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
     }
    
    @objc func dismissView() {
        dismiss(animated: true)
        _ = navigationController?.popViewController(animated: true)
    }
}
