//
//  YLContainerView.swift
//  WaterFlow
//
//  Created by YangXL on 2017/11/28.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class YLContainerView: UIView {
    
    fileprivate lazy var wrapView:UIView = self.makeWrapView()
    fileprivate lazy var shapLayer:CAShapeLayer = self.addDash()
    fileprivate lazy var deleteIcon:UIImageView = self.makeDeleteIcon()
    fileprivate lazy var editIcon:UIImageView = self.makeEditIcon()
    fileprivate lazy var moveIcon:UIImageView = self.makeMoveIcon()
    fileprivate lazy var wrapImageView:UIImageView = self.makeWrapImageView()
    fileprivate var model:YLWrapModel!
    var touchStart:CGPoint!
    var startPoint:CGPoint!
    var prevPoint:CGPoint!
    var deltaAngle:CGFloat!
    var isHiddening:Bool! = true
    let kWidth:CGFloat = 160
    let minW:CGFloat = 100
    let innerEdges:CGFloat = 15
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience  init(_ model:YLWrapModel) {
        self.init()
        self.model = model
        //        9610204149484
        touchStart = CGPoint.zero
        self.backgroundColor = UIColor.clear
        
        self.addSubview(self.wrapView)
        self.wrapView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(UIEdgeInsetsMake(10, 10, 10, 10))
        }
        
        self.wrapImageView.image = UIImage(named:model.imageName)
        
        
        self.wrapView.addSubview(self.wrapImageView)
        self.wrapImageView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(UIEdgeInsetsMake(innerEdges, innerEdges, innerEdges, innerEdges))
        }
//
        self.frame = CGRect(x: 100, y: 100, width: kWidth, height: kWidth)
        
        wrapView.layer.addSublayer(self.shapLayer)
      
        
        [deleteIcon,editIcon,moveIcon].forEach {
            self.addSubview($0)
        }
        deleteIcon.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(30)
            maker.left.top.equalToSuperview()
        }
        editIcon.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(30)
            maker.right.top.equalToSuperview()
        }
        moveIcon.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(30)
            maker.bottom.right.equalToSuperview()
        }
        self.setNeedsDisplay()
        deltaAngle = atan2(self.frame.maxY - self.center.y, self.frame.maxX - self.center.x)
        let moveGesture  = UIPanGestureRecognizer(target: self, action: #selector(moveGesture(_:)))
        
        moveIcon.addGestureRecognizer(moveGesture)
        
        
        let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(selected(_:)), name: NSNotification.Name(rawValue: "containerView"), object: nil)
        
        hide()
    }
    @objc func selected(_ noti:Notification){
       let model =  noti.object as? YLWrapModel
        
        if  self.model.id == model?.id{
            return
        }else{
            self.hide()
        }
    }
    @objc func tapGesture(_ gesture:UITapGestureRecognizer){
        show()
    }
    
    func show() {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: wrapView.frame.width-1, height: wrapView.frame.height-1), cornerRadius: 3)
        shapLayer.path = path.cgPath
        shapLayer.bounds = CGRect(x: 0, y: 0, width: wrapView.frame.width-1, height: wrapView.frame.height-1)
        shapLayer.position = CGPoint(x:wrapView.frame.midX - 10,y:wrapView.frame.midY-10)
        [deleteIcon,editIcon,moveIcon].forEach {
            $0.isHidden = false
        }
        self.isHiddening = false
        self.superview?.bringSubview(toFront: self)
        
        NotificationCenter.default.post(name: NSNotification.Name.init("containerView"), object: self.model)
    }
    func hide() {
        [deleteIcon,editIcon,moveIcon].forEach {
            $0.isHidden = true
        }
        self.isHiddening = true
        shapLayer.path = nil
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func panGesture(_ gesture:UIPanGestureRecognizer){
        
        let point =   gesture.translation(in: gesture.view)
        self.center =   CGPoint(x: self.center.x + point.x, y: self.center.y + point.y)
        gesture.setTranslation(CGPoint(x: 0, y: 0), in: self)
        
    }
    @objc func moveGesture(_ gesture:UIPanGestureRecognizer){
        if gesture.state == .began{
            prevPoint = gesture.location(in: self)
            self.setNeedsLayout()

            
            
        }else if gesture.state == .changed{
            
            let point = gesture.location(in: self)
            var wChange:CGFloat = 0.0,hChange:CGFloat = 0.0
            wChange =  point.x - prevPoint.x
            hChange = wChange/self.bounds.width*self.bounds.height
            let finalWidth = self.bounds.width + wChange*2
            let finalHeight = self.bounds.height + hChange*2
             if finalWidth < minW{
                  prevPoint = gesture.location(ofTouch: 0, in: self)
                return
            }
            self.bounds = CGRect(x:self.bounds.origin.x,y:self.bounds.origin.y,width:finalWidth,height:finalHeight)
            
          
            prevPoint = gesture.location(ofTouch: 0, in: self)

            
            let ang =   atan2(gesture.location(in: self.superview).y - self.center.y,  gesture.location(in: self.superview).x - self.center.x )
            let angleDiff =   deltaAngle - ang
            self.transform = CGAffineTransform(rotationAngle:-angleDiff)
            self.layoutIfNeeded()
        }else if gesture.state == .ended{
            prevPoint =  gesture.location(in: self  )
            self.setNeedsDisplay()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
 
        guard !isHiddening else {
            return
        }
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: wrapView.frame.width-1, height: wrapView.frame.height-1), cornerRadius: 3)
        shapLayer.path = path.cgPath
        shapLayer.bounds = CGRect(x: 0, y: 0, width: wrapView.frame.width-1, height: wrapView.frame.height-1)
        shapLayer.position = CGPoint(x:wrapView.frame.midX - 10,y:wrapView.frame.midY-10)
//        self.superview?.bringSubview(toFront: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        touchStart = touch.location(in: self.superview)
        startPoint = touch.location(in:self)
        self.show()

        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        if  self.moveIcon.frame.contains(startPoint) || self.deleteIcon.frame.contains(startPoint) ||
            self.editIcon.frame.contains(startPoint){
            return
        }
        
        let touchPoint = touch.location(in: self.superview)
        let newCenter = CGPoint(x: (self.center.x + touchPoint.x - touchStart.x), y: (self.center.y + touchPoint.y - touchStart.y))
        
        self.center = newCenter
        
        
        touchStart = touchPoint
    }
    
    
    
    func makeWrapView() -> UIView{
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        return view
    }
    
    func addDash() ->CAShapeLayer{
        let shapLayer = CAShapeLayer.init()
        shapLayer.strokeColor = UIColor.white.cgColor
        shapLayer.fillColor = UIColor.clear.cgColor
        
        shapLayer.lineWidth = 1
        shapLayer.lineDashPattern = [12,12]
        
        return shapLayer
    }
    
    func makeDeleteIcon() -> UIImageView {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named:"water_delete")
        image.isUserInteractionEnabled = true
        
        return image
    }
    func makeEditIcon() -> UIImageView {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named:"water_edit")
        image.isUserInteractionEnabled = true
        
        return image
    }
    func makeMoveIcon() -> UIImageView {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named:"water_change")
        image.isUserInteractionEnabled = true
        return image
    }
    func makeWrapImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.clear
        imageView.clipsToBounds = true
        return imageView
    }
}
