//
//  Model+DataSource.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

extension Model: UIPageViewControllerDataSource {

    // MARK: - UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.index(of: viewController as? DishViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }

        index -= 1
        return dishViewController(at: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.index(of: viewController as? DishViewController)
        if index == NSNotFound {
            return nil
        }
        index += 1
        if index == dishes.count {
            return nil
        }

        return dishViewController(at: index)
    }

    // MARK: - Helpers

    func index(of viewController: DishViewController?) -> Int {
        guard let controller = viewController else { return NSNotFound }
        return dishes.index(of: controller.dish) ?? NSNotFound
    }

    func dishViewController(at index: Int) -> DishViewController? {
        if (dishes.count == 0) || (index >= dishes.count) {
            return nil
        }

        //swiftlint:disable:next line_length
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "DishViewController") as? DishViewController else {
            fatalError()
        }

        viewController.dish = dishes[index]
        return viewController
    }

}
