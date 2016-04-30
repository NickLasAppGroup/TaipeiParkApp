//
//  InfoViewController.swift
//  Demo_TaipeiPark
//
//  Created by HungChita on 2016/4/26.
//  Copyright © 2016年 HungChita. All rights reserved.
//

import UIKit
import CoreLocation

class InfoViewController: UIViewController {

    var location_label:UILabel!
    var management_label:UILabel!
    var telephoneNum:String = ""
    var mapVC:MapViewController?
    var ary_location = [(lat:String,lon:String,parkName:String)]()
    
    func refreshWithFrame(frame:CGRect,navH:CGFloat) {
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.view.frame = frame
        
        //=====================  location  ===================
        location_label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height/6))
        location_label.textAlignment = .Center
        location_label.center = CGPointMake(frame.size.width/2, frame.size.height/4)
        self.view.addSubview(location_label)
        
        let locationBt = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width/4, height: frame.size.height/6))
        locationBt.center = CGPointMake(frame.size.width/2, location_label.center.y + location_label.frame.size.height/2 + locationBt.frame.size.height/2 + 10)
        locationBt.backgroundColor = UIColor.blackColor()
        locationBt.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        locationBt.setTitle("位置", forState: .Normal)
        self.btAttribute(locationBt, shadowColor: UIColor.cyanColor())
        locationBt.tag = 1
        locationBt.addTarget(self, action: #selector(InfoViewController.alertShow(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(locationBt)
        
        //=====================  management  ===================
        management_label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height/6))
        management_label.textAlignment = .Center
        management_label.center = CGPointMake(frame.size.width/2, locationBt.center.y + locationBt.frame.size.height/2 + management_label.frame.size.height/2 + 30)
        self.view.addSubview(management_label)

        let managementBt = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width/4, height: frame.size.height/6))
        managementBt.center = CGPointMake(frame.size.width/2, management_label.center.y + management_label.frame.size.height/2 + managementBt.frame.size.height/2 + 10)
        managementBt.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        managementBt.setTitle("聯絡我們", forState: .Normal)
        managementBt.backgroundColor = UIColor.greenColor()
        self.btAttribute(managementBt, shadowColor: UIColor.blackColor())
        managementBt.addTarget(self, action: #selector(InfoViewController.alertShow(_:)), forControlEvents: .TouchUpInside)
        managementBt.tag = 2
        self.view.addSubview(managementBt)

    }
    
    func btAttribute(sender:UIButton,shadowColor:UIColor) {
        
        sender.layer.shadowColor = shadowColor.CGColor
        sender.layer.shadowOffset = CGSizeMake(2.0, 6.0)
        sender.layer.shadowOpacity = 0.8
    }
    
    func alertShow(sender:UIButton) {
        
        var _title:String = ""
        if sender.tag == 1 {
            
            _title = "開啟地圖 ?"
        }
        else if sender.tag == 2 {
            _title = "撥打電話 ?"
        }
        
        let alert = UIAlertController(title: _title, message: "", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "確定", style: .Default, handler: { (action) in
            
            if sender.tag == 1 {
                
                self.mapShow()
            }
            else if sender.tag == 2 {
                
                self.phoneCall()
            }
            
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .Destructive, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func phoneCall() {
        
        print("tel://"+"\(telephoneNum)")
        UIApplication.sharedApplication().openURL(NSURL(string:"tel://"+"\(telephoneNum)")!)
        
    }
    
    func mapShow() {
        
        if mapVC == nil {
            
            mapVC = MapViewController()
            mapVC?.refreshWithFrame(self.view.frame)
        }
        
        mapVC?.lat = CLLocationDegrees(self.ary_location[0].lat)
        mapVC?.long = CLLocationDegrees(self.ary_location[0].lon)
        
        print("jsonData:\(mapVC!.lat)/\(mapVC!.long)")
        
        mapVC?.parkName = self.ary_location[0].parkName
        self.navigationController?.pushViewController(mapVC!, animated: true)
    }

}
