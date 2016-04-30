//
//  ViewController.swift
//  Demo_TaipeiTravel
//
//  Created by HungChita on 2016/4/26.
//  Copyright © 2016年 HungChita. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var m_parkListVC:ParkListVC?
    var nav: UINavigationController?
    var frontimg:UIImageView?
    var VC: ViewController?
    
    func refreshWithFrame(frame:CGRect){
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.frame = frame
        
        
        let bt = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width))
        bt.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        bt.adjustsImageWhenHighlighted = false
        bt.setImage(UIImage(named:"frontpage.png" ), forState: .Normal)
        bt.addTarget(self, action: #selector(ViewController.onBtAction(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(bt)

        
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width/3, height: frame.size.height/10))
        titleLabel.center = CGPoint(x: self.view.frame.size.width/2, y: (frame.size.height/10)*8)
        titleLabel.text = "台北市公園表"
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(titleLabel)
    
        

        
    }
    

    func onBtAction(sender:UIButton) -> Void {
        
        if m_parkListVC ==  nil {
            
            m_parkListVC = ParkListVC()
            m_parkListVC?.refreshWithFrame(self.view.frame)
        }
        if nav == nil {
            nav = UINavigationController(rootViewController: m_parkListVC!)
        }
        self.presentViewController(nav!, animated: true, completion: nil)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
       
//        let titleLabel = UILabel(frame: CGRect(x: frame.size.width/4, y: (frame.size.height/10)*9, width: frame.size.width/3, height: frame.size.height/10))
//        titleLabel.text = "台北市公園表"
//        titleLabel.textColor = UIColor.blackColor()
//        titleLabel.textAlignment = NSTextAlignment.Center
//        self.view.addSubview(titleLabel)
        
    }
}

