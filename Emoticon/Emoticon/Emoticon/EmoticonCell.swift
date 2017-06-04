//
//  EmoticonCell.swift
//  08-表情键盘
//
//  Created by iOS Developer on 2017/5/26.
//  Copyright © 2017年 iOS Developer. All rights reserved.
//

import UIKit

class EmoticonCell: UICollectionViewCell {
    
    // MARK: - 定义的属性
    var emoticon : Emoticon? {
        didSet{
            guard emoticon != nil else {
                return
            }
            
            emoticonBtn.setImage(UIImage.init(contentsOfFile: (emoticon?.pngPath) ?? ""), for: .normal)
            emoticonBtn.setTitle(emoticon?.emojiCode, for: .normal)
            
            if (emoticon?.isRemove)! {
                emoticonBtn.setImage(UIImage.init(named: "compose_emotion_delete"), for: .normal)
            }
        }
    }
    
    
    // MARK: - 懒加载
    fileprivate lazy var emoticonBtn : UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension EmoticonCell
{
    fileprivate func setupUI(){
        //添加子空间
        contentView.addSubview(emoticonBtn)
        //设置frame
        emoticonBtn.frame = contentView.bounds
        //设置属性
        emoticonBtn.isUserInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
    }
}
