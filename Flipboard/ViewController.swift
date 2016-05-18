//
//  ViewController.swift
//  Flipboard
//
//  Created by jiangbo on 16/5/11.
//  Copyright © 2016年 chenrui. All rights reserved.
//

import UIKit
let Screnn_Width = UIScreen.mainScreen().bounds.width
let Screnn_height = UIScreen.mainScreen().bounds.height
let Screnn_Scale = UIScreen.mainScreen().bounds.width/320
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view, typically from a nib.
        let layout = MainLayout()
        let collectionView = MainCollectionView(frame: CGRectMake(0, 0,Screnn_Width, Screnn_height), collectionViewLayout: layout)
        self.view.addSubview(collectionView)
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        //更新statusbar的颜色
        self.navigationController?.navigationBarHidden = true
        self.setNeedsStatusBarAppearanceUpdate()
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        //设置satatusbar为白色
        return UIStatusBarStyle.LightContent
    }

}

