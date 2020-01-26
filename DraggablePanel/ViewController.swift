//
//  ViewController.swift
//  DraggablePanel
//
//  Created by Yuchen Zhong on 2017-06-11.
//  Copyright © 2017 Yuchen Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let draggablePanelViewController = DraggablePanelViewController.create()
     
        self.addChild(draggablePanelViewController)
        self.view.addSubview(draggablePanelViewController.view)
        draggablePanelViewController.didMove(toParent: self)
        
        let height = view.frame.height
        let width  = view.frame.width
        draggablePanelViewController.view.frame = CGRect(x: 0, y: view.frame.maxY, width: width, height: height)
    }
}

