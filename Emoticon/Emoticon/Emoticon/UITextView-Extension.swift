//
//  UITextView-Extension.swift
//  08-表情键盘
//
//  Created by iOS Developer on 2017/5/26.
//  Copyright © 2017年 iOS Developer. All rights reserved.
//

import UIKit


extension UITextView
{
    /// 获取textView的字符串 和表情字符串
    func getEmoticonString() -> String {
        //获取属性字符串
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        let rang = NSRange(location: 0, length: attrMStr.length)
        //遍历属性字符串
        attrMStr .enumerateAttributes(in: rang, options: []) { (dict, range, _) in
            if let attachment = dict["NSAttachment"] as? EmoticonAttachment {
                attrMStr.replaceCharacters(in: rang, with: attachment.chs!)
            }
        }
        //获取字符串
        return attrMStr.string
    }
    
    /// 给textView 插入表情
    func insertEmoticon(emoticon : Emoticon) {
        
        //空白表情
        if emoticon.isEmpty {
            return
        }
        //删除按钮
        if emoticon.isRemove {
            deleteBackward()
            return
        }
        //emoji表情
        if emoticon.emojiCode != nil {
            //获取光标所在位置的range
            let textRang = selectedTextRange
            //替换表情
            replace(textRang!, withText: emoticon.emojiCode!)
            
            return
        }
        //图文混排
        //根据图片路径创建属性字符串
        let attachment = EmoticonAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        let font = self.font
        attachment.bounds = CGRect(x: 0, y: -4, width: (font?.lineHeight)!, height: (font?.lineHeight)!)
        let attrImageStr = NSAttributedString(attachment: attachment)
        //创建可见字符串
        let attrMub = NSMutableAttributedString(attributedString: attributedText)
        //获取光标位置d
        let textRang = selectedRange
        //替换属性字符串
        attrMub.replaceCharacters(in: textRang, with: attrImageStr)
        //显示字符串
        attributedText = attrMub
        //文字大小重置
        self.font = font
        //将光标设置会原来的位置 + 1
        selectedRange = NSRange(location: textRang.location + 1, length: 0)
        
    }
}
