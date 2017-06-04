//
//  ViewController.swift
//  Emoticon
//
//  Created by DragonLee on 2017/6/4.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    private lazy var emoticonVc : EmoticonViewController = EmoticonViewController {[weak self] (emoticon) in
        self!.textView.insertEmoticon(emoticon: emoticon)
    }
    //发送按钮的点击
    @IBAction func sendBtn(_ sender: AnyObject) {
        print(textView.getEmoticonString())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.inputView = emoticonVc.view
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
}

