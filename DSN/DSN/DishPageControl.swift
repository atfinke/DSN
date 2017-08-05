//
//  DishPageControl.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

class DishPageControl: UIPageControl {

    // MARK: - Properties

    let pageCircle: UIImage = #imageLiteral(resourceName: "selected")

    override var numberOfPages: Int {
        didSet {
            updateDots()
        }
    }

    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }

    // MARK: - View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        self.pageIndicatorTintColor = UIColor.clear
        self.currentPageIndicatorTintColor = UIColor.clear
        self.clipsToBounds = false
    }

    // MARK: - Helpers

    func updateDots() {
        for (index, subview) in self.subviews.enumerated() {
            let imageView = self.imageView(for: subview)
            if index == self.currentPage {
                imageView.alpha = 1.0
            } else {
                imageView.alpha = 0.5
            }
        }
    }

    fileprivate func imageView(for view: UIView) -> UIImageView {
        if let imageView = view as? UIImageView {
            return imageView
        }
        for subview in view.subviews {
            if let imageView = subview as? UIImageView {
                return imageView
            }
        }
        let newImageView = UIImageView(image: pageCircle)
        newImageView.center = CGPoint(x: view.center.x, y: view.center.y + 2.5)
        view.addSubview(newImageView)
        view.clipsToBounds = false
        return newImageView
    }
}
