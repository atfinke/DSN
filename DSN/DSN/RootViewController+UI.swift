//
//  RootViewController+UI.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit
import SceneKit

extension RootViewController {

    // MARK: - Interface Creation

    func setupInterface() {
        guard let navigationController = navigationController else {
            fatalError()
        }

        for subview in pageViewController.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
            }
        }

        createLabels()
        configure(effectView: foregroundStarView, effectValue: 30)
        configure(effectView: backgroundStarView, effectValue: 15)

        pageViewController.delegate = self
        pageViewController.dataSource = model

        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)

        thinLine.backgroundColor = UIColor.lightGray
        thinLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(thinLine)

        dishView.rotate()
        dishView.translatesAutoresizingMaskIntoConstraints = false
        navigationController.view.addSubview(dishView)

        view.bringSubview(toFront: toolbar)

        toolbar.alpha = 0.0
        thinLine.alpha = 0.0
        pageViewController.view.alpha = 0.0

        reloadBarButtonItem = toolbar.items?.first

        let constraints: [NSLayoutConstraint] = [
            thinLine.leftAnchor.constraint(equalTo: view.leftAnchor),
            thinLine.rightAnchor.constraint(equalTo: view.rightAnchor),
            thinLine.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            thinLine.heightAnchor.constraint(equalToConstant: 1.0),

            dishView.widthAnchor.constraint(equalTo: navigationController.view.widthAnchor),
            dishView.heightAnchor.constraint(equalTo: navigationController.view.heightAnchor, multiplier: 0.5),
            dishView.centerXAnchor.constraint(equalTo: navigationController.view.centerXAnchor),
            dishView.bottomAnchor.constraint(equalTo: navigationController.view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)

        createStars()
        createGradients()
    }

    private func createLabels() {
        siteLabel.text = "CONNECTING TO\nDEEP SPACE NETWORK"
        siteLabel.numberOfLines = 0
        siteLabel.textAlignment = .center
        siteLabel.textColor = UIColor.white
        siteLabel.font = UIFont.boldSystemFont(ofSize: 30)
        siteLabel.adjustsFontSizeToFitWidth = true
        siteLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(siteLabel)

        animatingInSiteLabel.text = ""
        animatingInSiteLabel.textAlignment = .center
        animatingInSiteLabel.textColor = UIColor.white
        animatingInSiteLabel.font = UIFont.boldSystemFont(ofSize: 30)
        animatingInSiteLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animatingInSiteLabel)

        siteLabelTopConstraint = siteLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20)
        siteLabelRightConstraint = siteLabel.rightAnchor.constraint(equalTo: view.rightAnchor)
        animatingInSiteLabelRightConstraint = animatingInSiteLabel.rightAnchor.constraint(equalTo: view.rightAnchor)

        view.bringSubview(toFront: toolbar)

        toolbar.alpha = 0.0
        thinLine.alpha = 0.0
        pageViewController.view.alpha = 0.0

        let constraints: [NSLayoutConstraint] = [
            siteLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            siteLabel.heightAnchor.constraint(equalToConstant: 60),

            animatingInSiteLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            animatingInSiteLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            animatingInSiteLabel.heightAnchor.constraint(equalToConstant: 60),

            siteLabelTopConstraint,
            siteLabelRightConstraint,
            animatingInSiteLabelRightConstraint
        ]
        NSLayoutConstraint.activate(constraints)

        view.bringSubview(toFront: backgroundStarView)
        view.bringSubview(toFront: foregroundStarView)

        siteBlinkTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1.0, animations: {
                    if self.siteLabel.alpha == 0.75 {
                        self.siteLabel.alpha = 1.0
                    } else {
                        self.siteLabel.alpha = 0.75
                    }
                })
            }
        })

    }

    private func createStars() {
        let foregroundStarsPath = UIBezierPath()
        for x in 0...Int(view.frame.width / 8) {
            let number = Double(400 + -randomNumber(probabilities: ( 0...400).map({ Double($0) })))
            let path = UIBezierPath(ovalIn: CGRect(x:  Double(x * 8), y: number, width: 2.5, height: 1.5))
            foregroundStarsPath.append(path)
        }
        let foregroundStars = CAShapeLayer()
        foregroundStars.path = foregroundStarsPath.cgPath
        foregroundStars.fillColor = UIColor.white.cgColor
        foregroundStarView.layer.sublayers = nil
        foregroundStarView.layer.addSublayer(foregroundStars)

        let backgroundStarsPath = UIBezierPath()
        for x in 0...Int(view.frame.width / 2) {
            let number = Double(600 + -randomNumber(probabilities: ( 0...600).map({ Double($0) })))
            let path = UIBezierPath(ovalIn: CGRect(x: 10.0 + Double(x * 2), y: number, width: 1.5, height: 1.5))
            backgroundStarsPath.append(path)
        }
        let backgroundStars = CAShapeLayer()
        backgroundStars.path = backgroundStarsPath.cgPath
        backgroundStars.fillColor = UIColor.white.cgColor
        backgroundStarView.layer.sublayers = nil
        backgroundStarView.layer.addSublayer(backgroundStars)
    }

    private func createGradients() {
        contentFadeLayer.colors = [
            UIColor(white: 1.0, alpha: 0.0).cgColor,
            UIColor(white: 1.0, alpha: 1.0).cgColor
        ]
        contentFadeLayer.locations = [
            NSNumber(value: 65.0 / Double(view.frame.height)),
            NSNumber(value: 135.0 / Double(view.frame.height))
        ]
        contentFadeLayer.bounds = pageViewController.view.frame
        contentFadeLayer.anchorPoint = .zero

        horizontalMask.colors = [
            UIColor(white: 1.0, alpha: 0.5).cgColor,
            UIColor(white: 1.0, alpha: 1.0).cgColor,
            UIColor(white: 1.0, alpha: 1.0).cgColor,
            UIColor(white: 1.0, alpha: 0.5).cgColor
        ]
        horizontalMask.locations = [
            NSNumber(value: 0.0),
            NSNumber(value: 20.0 / Double(view.frame.width)),
            NSNumber(value: Double(view.frame.width - 20) / Double(view.frame.width)),
            NSNumber(value: 1.0)
        ]
        horizontalMask.bounds = pageViewController.view.frame
        horizontalMask.anchorPoint = .zero
        horizontalMask.startPoint = CGPoint(x: 0, y: 0.5)
        horizontalMask.endPoint = CGPoint(x: 1.0, y: 0.5)

        view.layer.mask = horizontalMask
        pageViewController.view.layer.mask = contentFadeLayer
    }

    // MARK: - Helpers

    private func configure(effectView: UIView, effectValue: Double) {
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.backgroundColor = UIColor.clear
        view.addSubview(effectView)

        let xEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xEffect.minimumRelativeValue = effectValue
        xEffect.maximumRelativeValue = -effectValue
        effectView.addMotionEffect(xEffect)

        let yEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yEffect.minimumRelativeValue = effectValue
        yEffect.maximumRelativeValue = -effectValue
        effectView.addMotionEffect(yEffect)

        let constraints = [
            effectView.topAnchor.constraint(equalTo: view.topAnchor),
            effectView.leftAnchor.constraint(equalTo: view.leftAnchor),
            effectView.rightAnchor.constraint(equalTo: view.rightAnchor),
            effectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    // http://stackoverflow.com/questions/30309556/generate-random-numbers-with-a-given-distribution
    private func randomNumber(probabilities: [Double]) -> Int {
        let sum = probabilities.reduce(0, +)
        let rnd = sum * Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max)
        var accum = 0.0
        for (i, p) in probabilities.enumerated() {
            accum += p
            if rnd < accum {
                return i
            }
        }
        return (probabilities.count - 1)
    }

    // MARK: - View Transitions

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (_) in
            self.createStars()
            self.createGradients()
        }, completion: nil)
    }

}
