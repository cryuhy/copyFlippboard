//
//  ImageViewController.swift
//  Flipboard
//
//  Created by jiangbo on 16/5/17.
//  Copyright © 2016年 chenrui. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    var animationPoint:CGPoint?//用于动画开始的点
    var maskLayer:CAShapeLayer?
    var imageView:UIImageView? = nil
    var image:UIImage? = nil{
        willSet{
            let scale = (newValue?.size.height)!/(newValue?.size.width)!
            var imageHeight = Screnn_Width*scale
            if imageHeight>Screnn_height {
                imageHeight = Screnn_height
            }
            self.imageView?.frame = CGRectMake(0, 0, Screnn_Width, imageHeight)
        }
        didSet{
            
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(image:UIImage,animationPoint:CGPoint) {
        self.image = image
        self.animationPoint = animationPoint
        
        self.imageView = UIImageView(frame: CGRectMake(0, 0, Screnn_Width, Screnn_height))
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.imageView?.userInteractionEnabled = true
        self.imageView?.image = self.image
        super.init(nibName: nil, bundle: nil)
    }
    func configure(){
        self.maskLayer = CAShapeLayer()
        self.maskLayer?.fillColor = UIColor.clearColor().CGColor
        self.maskLayer?.strokeColor = UIColor.redColor().CGColor
        self.maskLayer?.lineWidth = 50
        self.maskLayer?.frame = CGRectMake(0, 0, Screnn_Width, Screnn_height)
        self.maskLayer?.path = UIBezierPath(ovalInRect: CGRectMake((animationPoint?.x)!-50, (animationPoint?.y)!-50, 50, 50)).CGPath
        self.view.layer.mask = self.maskLayer
        
        //先将maskView的属性直接不做动画设置到目标值，这样当动画完成以后就不会返回为原来的样子，就不会闪一下
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        self.maskLayer?.path = UIBezierPath(ovalInRect: CGRectMake(0, 0, Screnn_height, Screnn_height)).CGPath
        self.maskLayer?.lineWidth = Screnn_height
        CATransaction.commit()
        
        //添加动画
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = UIBezierPath(ovalInRect: CGRectMake((animationPoint?.x)!-50, (animationPoint?.y)!-50, 50, 50)).CGPath
        animation.toValue = UIBezierPath(ovalInRect: CGRectMake(0, 0, Screnn_height, Screnn_height)).CGPath
        animation.delegate = self
        let linWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        linWidthAnimation.fromValue = 50
        linWidthAnimation.toValue = Screnn_height
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animation, linWidthAnimation]
        groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        groupAnimation.duration = 1
        groupAnimation.delegate = self
        
        self.maskLayer?.addAnimation(groupAnimation, forKey: "stroke")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.translucent = true
        
        self.configure()
        
        self.view.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.imageView!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.view.addSubview(imageView!)
        // Dispose of any resources that can be recreated.
    }
//    func backClicked(sender:UIButton){
//        self.navigationController?.popViewControllerAnimated(true)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //动画代理
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.maskLayer?.removeFromSuperlayer()
    }

}
