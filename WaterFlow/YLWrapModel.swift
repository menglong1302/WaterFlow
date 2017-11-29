//
//  File.swift
//  WaterFlow
//
//  Created by YangXL on 2017/11/29.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import ObjectMapper
class YLWrapModel: Mappable {
    
    var imageName = "icon1"
    var isShowEdit:Bool = true
    var id:String = UUID().uuidString
    
    required init?(map: Map) {
        
    }
    init() {
        
    }
    func mapping(map: Map) {
        imageName <- map["imageName"]
    }
}
