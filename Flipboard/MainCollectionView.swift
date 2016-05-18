//
//  MainCollectionView.swift
//  Flipboard
//
//  Created by jiangbo on 16/5/12.
//  Copyright © 2016年 chenrui. All rights reserved.
//

import UIKit

class MainCollectionView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    //创建gcd队列加载图片
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    let identify = "MessageCell"
    let sectionIdentify = "SectionCell"
    let startDatas = ["32772_1001.jpg","41859_1001.jpg","46773_1002.jpg","49476_1001.jpg","49738_1001.jpg","54509_1001.jpg","56167_1001.jpg","59539_1001.jpg"
        ,"62396_1001.jpg","62858_1001.jpg","63008_1001.jpg","64669_1001.jpg","65107_1001.jpg","66617_1001.jpg"]
    let cartoonDatas = ["-29fece387c25a4c9.jpg","-56c26bcb20217781.jpg","-70c8bbefdb17082d.jpg","img-1ceda43a4cb3d87ce45e50025a090194.jpg"
        ,"img-1e727202be709f2b99c7a61ed1ee35dc.jpg","img-6c30dc9c733361412799e970898bd9d8.jpg","img-25f3e63cabb6093600aafdea44b6d4f1.jpg"
        ,"img-443f7502845d25b67187633a55b42cc0.jpg","img-775d86b319ec3c0c37a27fe4168dc796.jpg","img-1600fa8214ac0d07461501a8598b253b.jpg"
        ,"img-0176185fda3cd761719e596f49e1fb07.jpg","img-a9e18cef62113230d2491a3694e81097.jpg","img-d42960cedf519c1c6c615f197a9dcca6.jpg","img-f26b0319afe640cc76d3c00a1cd4176c.jpg"]
    let sectionDatas = ["3641C458-7047-49D1-B41B-27F878D6F164","img-4da28b5c4f56e6f7dea96666691da52b"
        ,"img-12fcdb93aa6c73782f3d2e2782884501","img-845b6367b93e1b42e558d297dd0cb449","img-ac2e12e25f62a2a396ebbc2afe48bc2d","img-eedb1bc71fdd79982ba5c2c60acd06b6","img-f2cca1dc220d24140239626f8029f328"]
    //由于绘制毛玻璃图片很耗性能所以绘制以后就保存
    let blurImageArray = NSMutableArray()
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        for image in sectionDatas {
            let image = UIImage(named: image)
            let blurImage = image?.blurredImageWithRadius(20, iterations: 10, tintColor: UIColor.blackColor())
            blurImageArray.addObject(blurImage!)
        }
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.whiteColor()
        //模拟数据
       
        self.registerNib(UINib(nibName: "MessageCollectionViewCell", bundle:NSBundle.mainBundle() )
, forCellWithReuseIdentifier: identify)
        self.registerNib(UINib(nibName: "SectionView", bundle:NSBundle.mainBundle()), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionIdentify)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 7
    }
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionViewCell:MessageCollectionViewCell? = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as? MessageCollectionViewCell
        //避免重用的时候出现重用数据的缓存问题
        collectionViewCell?.leftImage.image = nil
        collectionViewCell?.rightImage.image = nil
        let count = indexPath.section*2+indexPath.row
        var imageLeft:UIImage? = nil
        var imageRight:UIImage? = nil
        dispatch_async(queue) {
            //这里有一点就是由于我用的图片太大了所以全部加载以后内存比较大，我考虑到了压缩，在这里压缩会频繁卡顿，其实可以早些把图片全部压缩的，但是为了模拟网络加载图片，我所有图片加载方法都试写在这个方法里面，所以压缩我就不考虑了
            imageLeft = UIImage(named:self.cartoonDatas[count])!
            imageRight = UIImage(named:self.startDatas[count])!
            collectionViewCell?.leftImageItem = imageLeft
            collectionViewCell?.rightImageItem = imageRight
            dispatch_sync(dispatch_get_main_queue(), {
                collectionViewCell?.addjustImageViewHeight()
                if collectionView.contentOffset.y <= 0 {
                    //第一次加载cell的图片
                    collectionViewCell!.leftImage.image = collectionViewCell!.leftImageItem
                    collectionViewCell!.rightImage.image = collectionViewCell!.rightImageItem
                }
            })
        }
        return collectionViewCell!
    }
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var collectionHeader:SectionView? = nil
        if kind == UICollectionElementKindSectionHeader {
             collectionHeader = collectionView .dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: sectionIdentify, forIndexPath: indexPath) as? SectionView
            collectionHeader?.imageView.image = nil
            collectionHeader?.imageItem = UIImage(named: self.sectionDatas[indexPath.section])
            collectionHeader?.imageView.image = collectionHeader?.imageItem
            collectionHeader?.maskImageView.image = blurImageArray[indexPath.section] as? UIImage
            if indexPath.section == 0 {
                collectionHeader?.isHeader = true
            }else{
                collectionHeader?.isHeader = false
            }
        }
        return collectionHeader!
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeMake(Screnn_Width, 300*Screnn_Scale)
        }else{
            return CGSizeMake(Screnn_Width, 220*Screnn_Scale)
        }
    }
    //由于加载的图片太大了所以采用微博首页加载图片的方式，当滑动停止以后才加载图片
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let collectionView = scrollView as! MainCollectionView
        let cells = collectionView.visibleCells()
        for cell  in cells {
            let messageCell = cell as! MessageCollectionViewCell
            messageCell.addjustImageViewHeight()
            messageCell.leftImage.image = messageCell.leftImageItem
            messageCell.rightImage.image = messageCell.rightImageItem
        }
    }
}
