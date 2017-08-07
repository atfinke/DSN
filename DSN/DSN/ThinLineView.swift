//
//  ThinLineView.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

class ThinLineView: UIView {

    static var height: CGFloat = 1.0

    class func add(to view: UIView, offset: CGFloat = 20.0) -> ThinLineView {
        let thinLine = ThinLineView()
        thinLine.backgroundColor = UIColor.gray
        thinLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(thinLine)

        let constraints = [
            thinLine.leftAnchor.constraint(equalTo: view.leftAnchor, constant: offset),
            thinLine.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -offset),
            thinLine.heightAnchor.constraint(equalToConstant: height)
        ]
        NSLayoutConstraint.activate(constraints)
        return thinLine
    }

}
