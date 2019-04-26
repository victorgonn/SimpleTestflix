//
//  UIViewExt.swift
//  SimpleTestflix
//
//  Created by Victor Valfre on 25/04/19.
//  Copyright © 2019 Victor Valfre. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func constraint(pattern:String, views:UIView...){
        var allViews : [String: UIView] = [:]
        
        for(index, view) in views.enumerated(){
            view.translatesAutoresizingMaskIntoConstraints = false
            allViews["v\(index)"] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: pattern,
                                                      options: .init(rawValue: 0),
                                                      metrics: nil,
                                                      views: allViews))
    }
    
}
