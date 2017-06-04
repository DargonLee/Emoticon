//
//  EmoticonViewController.swift
//  08-表情键盘
//
//  Created by iOS Developer on 2017/5/24.
//  Copyright © 2017年 iOS Developer. All rights reserved.
//

import UIKit

private let EmoticonCellID = "EmoticonCell"

class EmoticonViewController: UIViewController {

    // MARK: - 定义属性
    var emoticonCallBack : (_ emoticon : Emoticon) -> ()
    
    
    // MARK: - 懒加载
    fileprivate var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonCollectionViewLayout())
    fileprivate var toolBar : UIToolbar = UIToolbar()
    fileprivate var manager = EmoticonManger()
    
    // MARK: - 自定义构造函数
    init(emoticonCallBack : @escaping (_ emoticon : Emoticon) -> ()){
        
        self.emoticonCallBack = emoticonCallBack
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

    }

}

extension EmoticonViewController
{
    fileprivate func setupUI(){
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        //设置位置 VFL
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = UIColor.white
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.lightGray.cgColor
        toolBar.backgroundColor = UIColor.green
        
        // 2.设置子控件的frame
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["tBar" : toolBar, "cView" : collectionView] as [String : Any]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cView]-0-[tBar]-0-|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        
        //准备collectionView
        prepareForConllectionView()
        
        
        //准备toolbar
        prepareForToolBarView()
        
    }
    
    private func prepareForConllectionView(){
        
        //注册cell 和设置数据源
        collectionView.register(EmoticonCell.self, forCellWithReuseIdentifier: EmoticonCellID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        
        
        //设置布局
//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        let itemWH : CGFloat = UIScreen.main.bounds.size.width / 7
//        layout.itemSize = CGSize(width: itemWH, height: itemWH)
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
//        layout.scrollDirection = .horizontal
//        
//        let insertMargin = (collectionView.bounds.size.height - 3 * itemWH)/2
//        collectionView.contentInset = UIEdgeInsetsMake(insertMargin, 0, insertMargin, 0)
        
    }
    
    
    private func prepareForToolBarView(){
        
        let titles = ["最近","默认","emoji","浪小花"]
        
        //遍历标题创建item
        var index = 0
        var items = [UIBarButtonItem]()
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(itemClick(item :)))
            item.tag = index
            index += 1
            
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        //设置toolBar items 的数据
        items.removeLast()
        toolBar.items = items
        toolBar.tintColor = UIColor.orange
    }
    
    
    @objc private func itemClick(item : UIBarButtonItem){
        
        let itemTag = item.tag
        
        let indexPath = NSIndexPath(item: 0, section: itemTag)
        
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: true)
        
    }
    
}

extension EmoticonViewController : UICollectionViewDataSource,UICollectionViewDelegate
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = manager.packages[section]
        return package.emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonCellID, for: indexPath) as! EmoticonCell
        
        //设置数据
//        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.purple : UIColor.blue
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        cell.emoticon = emoticon
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        
        //将点击的表情添加到最近的分组中
        insertRecentlyEmoticon(emoticon: emoticon)
        
        //将表情回调给外部控制器
        emoticonCallBack(emoticon)
    }
    
    private func insertRecentlyEmoticon(emoticon : Emoticon) {
        if emoticon.isEmpty || emoticon.isRemove {
            return
        }
        //删除表情
        if (manager.packages.first?.emoticons.contains(emoticon))! {//原来有该表情
            let index = manager.packages.first?.emoticons.index(of: emoticon)
            manager.packages.first?.emoticons.remove(at: index!)
        }else{//原来没有该表情
            manager.packages.first?.emoticons.remove(at: 19)
        }
        
        //将表情插入到最近表情
        manager.packages.first?.emoticons.insert(emoticon, at: 0)
        
    }
    
}



class EmoticonCollectionViewLayout : UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        // 1.计算itemWH
        let itemWH = UIScreen.main.bounds.width / 7
        
        // 2.设置layout的属性
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .horizontal
        
        // 3.设置collectionView的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        let insetMargin = (collectionView!.bounds.height - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsets(top: insetMargin, left: 0, bottom: insetMargin, right: 0)
    }
}

