//
//  ViewController.swift
//  WaterFlow
//
//  Created by YangXL on 2017/11/28.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var aa:YLContainerView = YLContainerView(YLWrapModel())
    lazy var bb:YLContainerView = YLContainerView(YLWrapModel())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(aa)
        self.view.addSubview(bb)
        self.view.backgroundColor = UIColor.black
        
        let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        
     }
  @objc func tapGesture(_ gesture:UITapGestureRecognizer){
    NotificationCenter.default.post(name: NSNotification.Name.init("containerView"), object: nil)
   
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

