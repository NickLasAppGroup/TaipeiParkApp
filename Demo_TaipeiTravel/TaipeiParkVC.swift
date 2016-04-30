//
//  TaipeiParkVC.swift
//  Demo_TaipeiPark
//
//  Created by HungChita on 2016/4/26.
//  Copyright © 2016年 HungChita. All rights reserved.
//

import UIKit

class TaipeiParkVC: UIViewController {

    var imageV: UIImageView!
    var textV: UITextView!
    var m_navH:CGFloat!
    var infoVC:InfoViewController?
    var indicator:UIActivityIndicatorView?
    
    var info_ary = [(location:String,latitude:String,longitude:String,managementName:String,manageTelephone:String,parkName:String)]()
    
    func refreshWithFrame(frame:CGRect,navH:CGFloat) {
        self.view.backgroundColor = UIColor.blackColor()
        self.view.frame = frame
        m_navH = navH
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "公園資訊", style: .Plain, target: self, action: #selector(TaipeiParkVC.onBarBtItemAction(_:)))
        
        imageV = UIImageView(frame: CGRect(x: 0, y: navH, width: frame.size.width, height: frame.size.height/2))
        imageV.contentMode = .ScaleAspectFill
        self.view.addSubview(imageV)
        
        textV = UITextView(frame: CGRect(x: 0, y: navH + imageV.frame.size.height, width: frame.size.width, height: frame.size.height/2 - navH))
        textV.backgroundColor = UIColor.blackColor()
        textV.textColor = UIColor.whiteColor()
        textV.clipsToBounds = true
        textV.font = UIFont.systemFontOfSize(textV.frame.size.width/15)
        textV.editable = false
        self.view.addSubview(textV)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textV.contentOffset = CGPointMake(0, 0)
    }
    
    func onBarBtItemAction(sender:UIBarButtonItem) {
        
        if infoVC == nil {
            
            infoVC = InfoViewController()
            infoVC?.refreshWithFrame(self.view.frame, navH: self.navigationController!.navigationBar.frame.size.height)
        }
        
        infoVC?.location_label.text = self.info_ary[0].location == "" ? "暫無資料" : self.info_ary[0].location
        infoVC?.management_label.text = self.info_ary[0].managementName == "" ? "暫無資料" : self.info_ary[0].managementName
        infoVC?.telephoneNum = self.info_ary[0].manageTelephone == "" ? "02-23815132" : self.info_ary[0].manageTelephone
        
        infoVC?.ary_location = [(self.info_ary[0].latitude ,self.info_ary[0].longitude ,self.info_ary[0].parkName )]
        
        self.navigationController?.pushViewController(infoVC!, animated: true)
    }
    
    func showIndicator() {
        
        if indicator == nil {
            
            indicator = UIActivityIndicatorView(frame: CGRectZero)
        }
        indicator?.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/3)
        indicator?.activityIndicatorViewStyle = .WhiteLarge
        indicator?.hidesWhenStopped = true
        self.view.addSubview(indicator!)
    }
    

}
