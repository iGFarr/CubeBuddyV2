//
//  NavigationController+TabBar+Ext.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/27/22.
//

import UIKit

extension UINavigationController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return visibleViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }

    open override var shouldAutorotate: Bool {
        return visibleViewController?.shouldAutorotate ?? super.shouldAutorotate
    }
}

extension UITabBarController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let selected = selectedViewController {
            return selected.supportedInterfaceOrientations
        }
        return super.supportedInterfaceOrientations
    }

    open override var shouldAutorotate: Bool {
        if let selected = selectedViewController {
            return selected.shouldAutorotate
        }
        return super.shouldAutorotate
    }
}
