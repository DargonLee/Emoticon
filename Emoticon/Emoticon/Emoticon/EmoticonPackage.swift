//
//  EmoticonPackage.swift
//  08-表情键盘
//
//  Created by iOS Developer on 2017/5/25.
//  Copyright © 2017年 iOS Developer. All rights reserved.
//

import UIKit

class EmoticonPackage : NSObject{

    var emoticons : [Emoticon] = [Emoticon]()
    
    init(id : String) {
        
        super.init()
        
        if id == "" {
            //添加空白表情
            addEmptyEmoticon(isRecently: true)
            return
        }
        
        // 2.根据id拼接info.plist的路径
        let plistPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        
        let array = NSArray(contentsOfFile: plistPath) as! [[String : String]]
        
        var index = 0
        
        for var dict in array {
            
            if let png = dict["png"] {
                dict["png"] = id + "/" + png
            }
            emoticons.append(Emoticon(dict: dict))
            
            index += 1
            if index == 20 {//添加删除按钮
                emoticons.append(Emoticon.init(isRemove: true))
                index = 0
            }
            
        }
        
        //添加空白表情
        addEmptyEmoticon(isRecently: false)
        
    }
    
    private func addEmptyEmoticon(isRecently : Bool){
        let count = emoticons.count % 21
        if count == 0,!isRecently {
            return
        }
        
        for _ in count..<20 {
            emoticons.append(Emoticon(isEmpty: true))
        }
        
        emoticons.append(Emoticon(isRemove: true))
        
    }
    
}
