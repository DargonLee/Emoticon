//
//  Emoticon.swift
//  08-表情键盘
//
//  Created by iOS Developer on 2017/5/25.
//  Copyright © 2017年 iOS Developer. All rights reserved.
//

import UIKit

class Emoticon : NSObject{

    var code : String? { //emoji 的表情
        didSet{
            guard code != nil else {
                return
            }
            
            //创建扫面器
            let scanner = Scanner(string: code!)
            
            //调用方法扫描中code中的值
            var vaule : UInt32 = 0
            scanner.scanHexInt32(&vaule)
            
            //将vaule转成字符
            let c = Character(UnicodeScalar(vaule)!)
           
            //将字符转成字符串
            emojiCode = String(c)
        }
    }
    var png  : String? {//普通表情
        didSet{
            guard png != nil else {
                return
            }
            
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png!
            
        }
    }
    var chs  : String?  //普通表情对应的文字
    
    // MARK: - 数据处理
    var pngPath : String?
    var emojiCode : String?
    var isRemove : Bool = false
    var isEmpty : Bool = false
    
    
    init(dict : [String : String]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    init (isRemove : Bool){
        self.isRemove = isRemove
        
    }
    
    init (isEmpty : Bool){
        self.isEmpty = isEmpty
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
    override var description: String {
        return dictionaryWithValues(forKeys: ["emojiCode","pngPath","chs"]).description
    }
    
}
