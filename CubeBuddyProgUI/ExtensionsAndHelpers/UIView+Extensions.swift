//
//  UIView+Extensions.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/4/22.
//

import UIKit

// Streamlines tap gestures on views
extension UIView {
        // In order to create computed properties for extensions, we need a key to
        // store and access the stored property
        fileprivate struct AssociatedObjectKeys {
            static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
        }
        
        fileprivate typealias Action = (() -> Void)?
        
        // Set our computed property type to a closure
        fileprivate var tapGestureRecognizerAction: Action? {
            set {
                if let newValue = newValue {
                    // Computed properties get stored as associated objects
                    objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                }
            }
            get {
                let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
                return tapGestureRecognizerActionInstance
            }
        }
        
        // This is the meat of the sauce, here we create the tap gesture recognizer and
        // store the closure the user passed to us in the associated object we declared above
        public func addTapGestureRecognizer(action: (() -> Void)?) {
            self.isUserInteractionEnabled = true
            self.tapGestureRecognizerAction = action
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
            self.addGestureRecognizer(tapGestureRecognizer)
        }
        
        // Every time the user taps on the UIImageView, this function gets called,
        // which triggers the closure we stored
        @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
            if let action = self.tapGestureRecognizerAction {
                action?()
            } else {
                print("no action")
            }
        }
}

// Convenience functions
extension UIView {
    public func addSubviews(_ views: [UIView]){
        for view in views {
            addSubview(view)
        }
    }
    
    public func top(_ yConstraint: NSLayoutYAxisAnchor) {
        topAnchor.constraint(equalTo: yConstraint).isActive = true
    }
    
    public func bottom(_ yConstraint: NSLayoutYAxisAnchor) {
        bottomAnchor.constraint(equalTo: yConstraint).isActive = true
    }
    
    public func leading(_ xConstraint: NSLayoutXAxisAnchor) {
        leadingAnchor.constraint(equalTo: xConstraint).isActive = true
    }
    
    public func trailing(_ xConstraint: NSLayoutXAxisAnchor) {
        trailingAnchor.constraint(equalTo: xConstraint).isActive = true
    }
    
    public func top(_ yConstraint: NSLayoutYAxisAnchor, constant: CGFloat) {
        topAnchor.constraint(equalTo: yConstraint, constant: constant).isActive = true
    }
    
    public func bottom(_ yConstraint: NSLayoutYAxisAnchor, constant: CGFloat) {
        bottomAnchor.constraint(equalTo: yConstraint, constant: constant).isActive = true
    }
    
    public func leading(_ xConstraint: NSLayoutXAxisAnchor, constant: CGFloat) {
        leadingAnchor.constraint(equalTo: xConstraint, constant: constant).isActive = true
    }
    
    public func trailing(_ xConstraint: NSLayoutXAxisAnchor, constant: CGFloat) {
        trailingAnchor.constraint(equalTo: xConstraint, constant: constant).isActive = true
    }
    
    public func heightEqualsHeightOf(_ view: UIView) {
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    public func heightEqualsHeightOf(_ view: UIView, constant: CGFloat) {
        heightAnchor.constraint(equalTo: view.heightAnchor, constant: constant).isActive = true
    }
    
    public func heightConstant(_ constant: CGFloat) {
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    public func widthEqualsWidthOf(_ view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    public func widthEqualsWidthOf(_ view: UIView, constant: CGFloat) {
        widthAnchor.constraint(equalTo: view.widthAnchor, constant: constant).isActive = true
    }
    
    public func widthConstant(_ constant: CGFloat) {
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    public func xAlignedWith(_ view: UIView) {
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    public func yAlignedWith(_ view: UIView) {
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
