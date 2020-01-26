//
//  DraggablePanelViewController.swift
//  DraggablePanel
//
//  Created by Yuchen Zhong on 2017-06-11.
//  Copyright © 2017 Yuchen Zhong. All rights reserved.
//

import Foundation
import UIKit

class DraggablePanelViewController : UIViewController {
    enum ExpandState {
        case collapse, partial, full
        
        var origin: CGPoint {
            switch self {
            case .collapse:
                return CGPoint.init(x: 0, y: UIScreen.main.bounds.height - 100)
            case .partial:
                return CGPoint.init(x: 0, y: UIScreen.main.bounds.height / 2)
            case .full:
                return CGPoint.init(x: 0, y: 0)
            }
        }
    }
    
    static func create() -> DraggablePanelViewController {
        return DraggablePanelViewController()
    }
    
    private let fullView: CGFloat = ExpandState.full.origin.y
    private var partialView: CGFloat = ExpandState.collapse.origin.y
    private var originBeginY: CGFloat = 0.0

    private func frame(for state: ExpandState) -> CGRect {
        return CGRect(origin: state.origin, size: self.view.frame.size)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture))
        view.addGestureRecognizer(gesture)
        
        self.view.layer.masksToBounds = false
        
        // corner radius
        view.layer.cornerRadius = 10
        
        // shadow
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 10.0

        view.backgroundColor = .yellow
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(
            withDuration: 0.6,
            delay: 0.0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 10,
            options: .allowUserInteraction,
            animations: {
                self.view.frame = self.frame(for: ExpandState.collapse)
        })
    }

    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        
        switch recognizer.state {
        case .began:
            originBeginY = self.view.frame.minY
        case .changed:
            let newY = originBeginY + translation.y
            if newY <= ExpandState.collapse.origin.y && newY >= ExpandState.full.origin.y {
                self.view.frame = CGRect(
                    x: 0,
                    y: newY,
                    width: view.frame.width,
                    height: view.frame.height
                )
            }
        case .ended:
            let newFrame: CGRect
            if velocity.y >= 0 {
                if self.view.frame.minY <= ExpandState.partial.origin.y {
                    newFrame = self.frame(for: ExpandState.partial)
                } else {
                    newFrame = self.frame(for: ExpandState.collapse)
                }
            } else {
                if self.view.frame.minY <= ExpandState.partial.origin.y {
                    newFrame = self.frame(for: ExpandState.full)
                } else {
                    newFrame = self.frame(for: ExpandState.partial)
                }
            }
            
            UIView.animate(
                withDuration: 0.5,
                delay: 0.0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 4.0,
                options: .allowUserInteraction,
                animations: {
                    self.view.frame = newFrame
            })
        case .possible, .cancelled, .failed:
            // Not needed
            break
        @unknown default:
            break
        }
    }
}
