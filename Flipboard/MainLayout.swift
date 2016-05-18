//
//  MainLayout.swift
//  Flipboard
//
//  Created by jiangbo on 16/5/12.
//  Copyright © 2016年 chenrui. All rights reserved.
//
import UIKit
let headerHeight = 300*Screnn_Scale
let sectionHeight = 220*Screnn_Scale
let alphaHeaderScale = 1/(headerHeight-64)//当section为0时的sectionView的alpha的比例
let alphaSectionScale = 1/(sectionHeight-64)
class MainLayout: UICollectionViewFlowLayout{
    var currentTopViewAttributes:UICollectionViewLayoutAttributes?
    override func prepareLayout() {
        super.prepareLayout()
        self.itemSize = CGSizeMake(Screnn_Width, 220)
        self.minimumLineSpacing = 0
    }
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElementsInRect(rect)
        let mutableAttributes = NSMutableArray(array: attributes!)
        let cells = self.collectionView?.visibleCells()
        for  cell in cells! {
            let messageCell = cell as! MessageCollectionViewCell
            messageCell.addjustImageViewHeight()
        }
        let sectionHeaers = self.collectionView?.visibleSupplementaryViewsOfKind(UICollectionElementKindSectionHeader)
        for item in sectionHeaers! {
            let scetion = item as! SectionView
            scetion.addjustImageViewHeight()
        }
        //sectionHeader attributes
        
        //举个例子，当rect区域内含有多个section的时候，但是最上面的section其实已经在rect的范围外了，但是这个section的cell还显示在屏幕的可视区域内。这时候section第一个section的attributes已经不在super.layoutAttributesForElementsInRect(rect)获取的数组里面了，所以为了让他还能显示在屏幕上面我们可以通过显示的cell来确定section的indexpath
        
        let missionHeaderIndexSet = NSMutableIndexSet()
        for item:UICollectionViewLayoutAttributes in attributes! {
            if item.representedElementCategory == UICollectionElementCategory.Cell {
                //通过在屏幕上的cell找到了相应的section
                missionHeaderIndexSet .addIndex(item.indexPath.section)
            }
            if item.representedElementKind ==  UICollectionElementKindSectionHeader{
                //此分支里面的attributes是在rect区域里面的,需要去除
                missionHeaderIndexSet.removeIndex(item.indexPath.section)
            }
        }
        //然后剩下的missionHeaderIndexSet集合里面就是本应该在屏幕上显示但是super.layoutAttributesForElementsInRect(rect)方法却没有的attributes
        missionHeaderIndexSet.enumerateIndexesUsingBlock({ (idx, stop) in
            //把不在rect的布局通过self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: indextPath)找到以后，添加到attributes里面，界面就可以布局这些本不该出现在屏幕区域内的section了
            let indextPath = NSIndexPath(forItem: 0, inSection: idx)
            let item = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: indextPath)
            mutableAttributes.addObject(item!)
        })
        let returnAttributes:[UICollectionViewLayoutAttributes] = NSArray(array: mutableAttributes) as! [UICollectionViewLayoutAttributes]
        for item:UICollectionViewLayoutAttributes in returnAttributes {
            let currentOffsetY = self.collectionView?.contentOffset.y
            if (item.representedElementKind == UICollectionElementKindSectionHeader) {
                    item.zIndex = 10
                //获取当前sectionHeader的rect
                let rect = item.frame
                let numberOfItemInSection = self.collectionView?.numberOfItemsInSection(item.indexPath.section)
                var firstItem:UICollectionViewLayoutAttributes? = nil
                var lastItem:UICollectionViewLayoutAttributes? = nil
                if numberOfItemInSection>0 {
                    firstItem = self.collectionView?.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: item.indexPath.section))
                    lastItem = self.collectionView?.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: max(0,numberOfItemInSection!-1) , inSection: item.indexPath.section))
                }else{
                    //如果这个section没有cell就假装一个cell
                    firstItem = UICollectionViewLayoutAttributes()
                    //然后模拟出在当前分区中的唯一一个cell，cell在header的下面，高度为0，还与header隔着可能存在的sectionInset的top
                    let y = CGRectGetMaxY(rect)+self.sectionInset.top
                    firstItem?.frame.origin.y = y
                    //因为只有一个cell，所以最后一个cell等于第一个cell
                    lastItem = firstItem

                }
                if item.indexPath.section == 0 {
                    if currentOffsetY>=headerHeight-64 {
                        item.frame.size.height = 64
                        let maxY = CGRectGetMaxY((lastItem?.frame)!)+self.sectionInset.bottom-item.frame.size.height
                        item.frame.origin.y = min(maxY, currentOffsetY!)
                    }else{
                        item.frame.size.height = headerHeight-currentOffsetY!
                        item.frame.origin.y = currentOffsetY!
                    }
                }else{
                    //当sectionHeader没有达到屏幕顶部时相关计算
                    if currentOffsetY >= (firstItem?.frame.origin.y)!-self.sectionInset.top-64 {
                        item.frame.size.height = 64
                    }else{
                        item.frame.size.height = min((firstItem?.frame.origin.y)! - currentOffsetY!, sectionHeight)
                    }
                    let replaceY = (firstItem?.frame.origin.y)!-self.sectionInset.top-item.size.height
                    let minY = max(replaceY, currentOffsetY!)
                    //当下一个sectionHeader已经抵到上一个sectionHeader的底部相关计算
                    let maxY = CGRectGetMaxY((lastItem?.frame)!)+self.sectionInset.bottom-item.frame.size.height
                    item.frame.origin.y = min(minY, maxY)
                }
            }
        }
        return returnAttributes
    }
//    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//        //创建sectionHeader  attributes
//        let attributes:UICollectionViewLayoutAttributes? = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withIndexPath: indexPath)
//        return attributes
//    }
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}
