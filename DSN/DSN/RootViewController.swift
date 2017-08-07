//
//  RootViewController.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit
import SceneKit

class RootViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            pageControl.numberOfPages = 0
        }
    }
    @IBOutlet weak var toolbar: UIToolbar! {
        didSet {
            toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
            toolbar.backgroundColor = UIColor.clear
        }
    }

    // MARK: - Properties

    let model = Model()
    var siteBlinkTimer: Timer?

    let thinLine = UIView()
    let dishView = DishView()

    let foregroundStarView = UIView()
    let backgroundStarView = UIView()

    let siteLabel = UILabel(frame: .zero)
    let animatingInSiteLabel = UILabel(frame: .zero)

    let horizontalMask = CAGradientLayer()
    let contentFadeLayer = CAGradientLayer()

    var siteLabelTopConstraint: NSLayoutConstraint!
    var siteLabelRightConstraint: NSLayoutConstraint!
    var animatingInSiteLabelRightConstraint: NSLayoutConstraint!

    var pendingViewController: DishViewController?
    let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal, options: nil)

    var reloadBarButtonItem: UIBarButtonItem!
    let loadingBarButtonItem: UIBarButtonItem = {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityView.sizeToFit()
        activityView.startAnimating()
        return UIBarButtonItem(customView: activityView)
    }()

    // MARK: - View States

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInterface()
        model.restartFetch()

        let startDate = Date()
        model.loadedDishes = {
            DispatchQueue.main.async {
                if self.dishView.superview != nil && -startDate.timeIntervalSinceNow < 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.modelLoaded()
                    }
                } else {
                    self.modelLoaded()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.toolbar.items?.insert(self.reloadBarButtonItem, at: 1)
                self.toolbar.items?.remove(at: 0)
            }
        }

        model.failedLoadingDishes = {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.presetConnectionAlert()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.toolbar.items?.insert(self.reloadBarButtonItem, at: 1)
                self.toolbar.items?.remove(at: 0)
            }
        }
    }

    // MARK: - Actions

    @IBAction func showInfo(_ sender: Any) {
        guard let url = URL(string:"https://en.wikipedia.org/wiki/NASA_Deep_Space_Network") else { fatalError() }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @IBAction func refresh(_ sender: Any) {
        if ProcessInfo.processInfo.arguments.contains("TARGET_SCREENSHOTS") {
            let vc = model.dishViewController(at: pageControl.currentPage + 1)
            pageViewController.setViewControllers([vc!], direction: .forward, animated: false, completion: nil)
            pageControl.currentPage += 1
            siteLabel.text = model.title(for: vc!.dish.site.displayName.uppercased())
            animatingInSiteLabel.text = model.title(for: vc!.dish.site.displayName.uppercased())
        } else {
            toolbar.items?.insert(self.loadingBarButtonItem, at: 1)
            toolbar.items?.remove(at: 0)
            model.restartFetch()
        }
    }

    // MARK: - Model Updates

    func modelLoaded() {
        guard pageControl.numberOfPages == 0 && !model.dishes.isEmpty else {
            return
        }

        func updateInterface() {
            pageControl.numberOfPages = model.dishes.count
            guard let viewController = model.dishViewController(at: 0) else { return }

            let newSite = viewController.dish.site.displayName.uppercased()
            siteLabel.text = model.title(for: newSite)
            animatingInSiteLabel.text = model.title(for: newSite)

            pageViewController.setViewControllers([viewController],
                                                  direction: .forward, animated: false, completion: {_ in })
        }

        UIView.animate(withDuration: 0.25, animations: {
            self.siteLabel.alpha = 0.0
            self.animatingInSiteLabel.alpha = 0.0
        }) { _ in
            self.siteLabelTopConstraint.constant = 0.0
            self.view.layoutIfNeeded()

            self.siteLabel.text = ""
            self.siteLabel.numberOfLines = 1

            updateInterface()

            UIView.animate(withDuration: 1.0, animations: {
                self.dishView.alpha = 0.0
                self.siteLabel.alpha = 0.25
                self.animatingInSiteLabel.alpha = 1.0
            }) { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    self.siteLabel.alpha = 1.0
                    self.toolbar.alpha = 1.0
                    self.thinLine.alpha = 1.0
                    self.pageViewController.view.alpha = 1.0
                })
                self.dishView.removeFromSuperview()
            }
        }

    }

    func presetConnectionAlert() {
        let title = "DSN Connection Failure"
        let message = "Unable to connect to the Deep Space Network."

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
            self.model.restartFetch()
        }))

        if pageControl.numberOfPages != 0 {
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        }

        present(alertController, animated: true, completion: nil)
    }

}
