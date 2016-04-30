//
//  ParkListVC.swift
//  Demo_TaipeiPark
//
//  Created by HungChita on 2016/4/26.
//  Copyright © 2016年 HungChita. All rights reserved.
//

import UIKit

class ParkListVC: UIViewController, UITableViewDelegate, UITableViewDataSource ,UISearchResultsUpdating{

    var tableView: UITableView?
    var ary_json = [AnyObject]()
    var indicator:UIActivityIndicatorView?
    var taipeiParkVC:TaipeiParkVC?
    
    var m_search:UISearchController?
    var m_search_ary = [String]()
    var ary_parkName = [String]()
    
    func refreshWithFrame(frame:CGRect){
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.view.frame = frame
        self.title = "台北市公園表"
        
        
        tableView = UITableView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        
        //TODO: - 0
        //m_search
        m_search = UISearchController(searchResultsController: nil)
        m_search?.searchResultsUpdater = self
        tableView?.tableHeaderView = m_search?.searchBar
        m_search?.dimsBackgroundDuringPresentation = false
        m_search?.hidesNavigationBarDuringPresentation = true
        m_search?.searchBar.placeholder = "請輸入關鍵字"
        m_search?.searchBar.tintColor = UIColor.whiteColor()
        m_search?.searchBar.barTintColor = UIColor.greenColor()

        
        self.showIndicator()
        indicator?.startAnimating()
        
        let url = NSURL(string: "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=8f6fcb24-290b-461d-9d34-72ed1b3f51f0")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (_data, _responce, _error) in
            
            if _error != nil {
                
                print("\(_error?.localizedDescription)")
                self.indicator?.stopAnimating()
                return
            }
            
            do {
                
                let jsonDic =  try NSJSONSerialization.JSONObjectWithData(_data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let dic = jsonDic.objectForKey("result")
                self.ary_json = dic?.objectForKey("results") as! [AnyObject]
                
                let operationQueue = NSOperationQueue()
                operationQueue.addOperationWithBlock({ 
                    
                    //TODO: 1
                    self.search_data(self.ary_json)
                })
                
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    
                    self.tableView?.reloadData()
                    self.indicator?.stopAnimating()
                })
                
            }catch {
                
                print("parseError")
            }
            
        }
        
        task.resume()
    }
    
    //MARK: - Delegate
    //---------------------------------------------------------
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //TODO: - 2
        //originalCode: return ary_json.count
        
        if m_search?.active == true {
            //當search功能在運作時
            return m_search_ary.count
            
        }else {
            
            return ary_json.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell_id:String = "CELL_ID"
        var cell = tableView.dequeueReusableCellWithIdentifier(cell_id) as UITableViewCell!
        if cell == nil {
            
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cell_id)
        }
        
        //TODO: - 3
        /*      
        originalCode:
        let dic = self.ary_json[indexPath.row] as! NSDictionary
        cell.textLabel?.text = dic.objectForKey("ParkName") as? String
        cell.detailTextLabel?.text = dic.objectForKey("ParkType") as? String
         */
        //當search功能在運作時,使用 m_search_ary,否則使用 ary_json
        let park = self.m_search?.active == true ? self.m_search_ary[indexPath.row] : self.ary_json[indexPath.row]
        cell.textLabel?.text = park.objectForKey("ParkName") as? String
        cell.detailTextLabel?.text = park.objectForKey("ParkType") as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if taipeiParkVC == nil {
            
            taipeiParkVC = TaipeiParkVC()
            taipeiParkVC?.refreshWithFrame(self.view.frame, navH: self.navigationController!.navigationBar.frame.size.height)
        }
        
        taipeiParkVC?.showIndicator()
        taipeiParkVC?.indicator?.startAnimating()
        
        //TODO: - 4
        /*
        originalode:
        let dic = self.ary_json[indexPath.row] as! NSDictionary
        let tuples = (
            
            dic.objectForKey("Location") as! String,
            dic.objectForKey("Latitude") as! String,
            dic.objectForKey("Longitude") as! String,
            dic.objectForKey("ManagementName") as! String,
            dic.objectForKey("ManageTelephone") as! String,
            dic.objectForKey("ParkName") as! String
        )
        self.taipeiParkVC?.info_ary = [tuples]
        self.taipeiParkVC?.textV.text = dic.objectForKey("Introduction") as? String
        self.taipeiParkVC?.title = dic.objectForKey("ParkName") as? String
         */
        let park = self.m_search?.active == true ? self.m_search_ary[indexPath.row] : self.ary_json[indexPath.row]
        let tuples = (
                park.objectForKey("Location") as! String,
                park.objectForKey("Latitude") as! String,
                park.objectForKey("Longitude") as! String,
                park.objectForKey("ManagementName") as! String,
                park.objectForKey("ManageTelephone") as! String,
                park.objectForKey("ParkName") as! String
            )
        self.taipeiParkVC?.info_ary = [tuples]
        self.taipeiParkVC?.textV.text = park.objectForKey("Introduction") as? String
        self.taipeiParkVC?.title = park.objectForKey("ParkName") as? String

        taipeiParkVC?.imageV.alpha = 0.0
        
        //===============  連結圖片  ================
        //TODO: - 5
        //let url = NSURL(string: dic.objectForKey("Image") as! String)
        let url = NSURL(string: park.objectForKey("Image") as! String)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (_data, _responce, _error) in
            
            if _error != nil {
                
                print("\(_error?.localizedDescription)")
                return
            }

            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                
                self.taipeiParkVC?.imageV.image = UIImage(data: _data!)
                self.taipeiParkVC?.imageV.alpha = 1.0
                self.taipeiParkVC?.indicator?.stopAnimating()
            })
        }
        task.resume()

        self.navigationController?.pushViewController(taipeiParkVC!, animated: true)
        
    }

//MARK: - showIndicator
//---------------------
    func showIndicator() {
        
        if indicator == nil {
            
            indicator = UIActivityIndicatorView(frame: CGRectZero)
        }
        indicator?.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        indicator?.activityIndicatorViewStyle = .WhiteLarge
        indicator?.color = UIColor.blueColor()
        indicator?.hidesWhenStopped = true
        self.view.addSubview(indicator!)
    }
    
//MARK: - search Delegate
//----------------------
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            
            self.filterSearchText(searchText)
            self.tableView?.reloadData()
        }
    }
    
    func filterSearchText(searchText:String) {
        
        if ((self.indicator?.stopAnimating()) != nil) {
            
            self.m_search_ary = self.ary_parkName.filter({ (str:String) -> Bool in
                
                let parkName_match = str.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil)
                
                return parkName_match != nil
            })
            
        }
    }
    
    
    func search_data(_ary:[AnyObject]) {
        
        for i in 0 ..< _ary.count {
            
            let dic = _ary[i] as! NSDictionary
            self.ary_parkName.append(dic.objectForKey("ParkName") as! String)
        }
        
    }

}//end class
