//
//  EmoticonManger.swift
//  08-表情键盘
//
//  Created by iOS Developer on 2017/5/25.
//  Copyright © 2017年 iOS Developer. All rights reserved.
//

import UIKit

class EmoticonManger {

    var packages : [EmoticonPackage] = [EmoticonPackage]()
    
    init() {
        //添加最近的表情包
        packages.append(EmoticonPackage(id : ""))
        
        //添加默认的表情包
        packages.append(EmoticonPackage(id : "com.sina.default"))
        
        //添加emoji的表情包
        packages.append(EmoticonPackage(id : "com.apple.emoji"))
        
        //添加浪小花的表情包
        packages.append(EmoticonPackage(id : "com.sina.lxh"))
    }
}
