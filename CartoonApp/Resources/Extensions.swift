//
//  Extensions.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 6/25/23.
//

import UIKit


extension UIView {

    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
