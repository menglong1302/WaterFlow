//
//  ViewController.swift
//  WaterFlow
//
//  Created by YangXL on 2017/11/28.
//  Copyright © 2017年 LYL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var aa:YLContainerView = YLContainerView(UIImage(named:"icon1")!)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(aa)
        aa.wrapImage = UIImage(named:"icon1")
        self.view.backgroundColor = UIColor.black
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

