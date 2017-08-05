//
//  RootViewController+PageView.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

extension RootViewController: UIScrollViewDelegate, UIPageViewControllerDelegate {

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let newSite = pendingViewController?.dish.site.displayName.uppercased() else {
            return
        }

        let point = scrollView.contentOffset
        let width = pageViewController.view.frame.size.width
        let percentComplete = min(fabs(point.x - width) / width, 1.0)

        guard let oldSite = siteLabel.text, percentComplete != 0.0 else {
            return
        }

        let newSiteWithFlag = model.title(for: newSite)
        let clippedOldSite = oldSite.substring(from: oldSite.index(oldSite.startIndex, offsetBy: 2))

        if newSite > clippedOldSite {
            animatingInSiteLabel.text = newSiteWithFlag
            siteLabelRightConstraint.constant = view.frame.width * percentComplete
            animatingInSiteLabelRightConstraint.constant = -view.frame.width * (1 - percentComplete)
            view.layoutIfNeeded()
        } else if newSite < clippedOldSite {
            animatingInSiteLabel.text = newSiteWithFlag
            siteLabelRightConstraint.constant = -view.frame.width * percentComplete
            animatingInSiteLabelRightConstraint.constant = view.frame.width * (1 - percentComplete)
            view.layoutIfNeeded()
        }

        if percentComplete == 1.0 {
            siteLabelRightConstraint.constant = 0
            animatingInSiteLabelRightConstraint.constant = 0
            view.layoutIfNeeded()

            siteLabel.text = newSiteWithFlag
            animatingInSiteLabel.text = newSiteWithFlag
        }
    }

    // MARK: - UIPageViewControllerDelegate

    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingViewController = pendingViewControllers.first as? DishViewController
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.last as? DishViewController else { return }
        let index = model.index(of: viewController)
        pageControl.currentPage = index

        let newSite = viewController.dish.site.displayName.uppercased()
        siteLabel.text = model.title(for: newSite)
        animatingInSiteLabel.text = model.title(for: newSite)
    }
    
}
