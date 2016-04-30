//
//  MapViewController.swift
//  Demo_TaipeiPark
//
//  Created by HungChita on 2016/4/26.
//  Copyright © 2016年 HungChita. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController,MKMapViewDelegate {
    
    var map:MKMapView!
    var geocoder:CLGeocoder!
    
    var m_locationManager:CLLocationManager?
    
    var location:CLLocation!
    
    var long:CLLocationDegrees!
    var lat:CLLocationDegrees!
    
    var parkName:String = ""
    
    func refreshWithFrame(frame:CGRect) {
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.view.frame = frame
        
        map = MKMapView(frame: frame)
        map.delegate = self
        self.view.addSubview(map)
        
        m_locationManager = CLLocationManager()
        
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0 {
            
            m_locationManager?.requestAlwaysAuthorization()
        }
        
        geocoder = CLGeocoder()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if geocoder == nil {
            
            geocoder = CLGeocoder()
        }
        
        location = CLLocation(latitude: self.lat, longitude: self.long)
        print("\(self.lat) / \(self.long)")
        
        geocoder.reverseGeocodeLocation(self.location) { (_placeMarks, error) in
            
            if error != nil {
                print("geocoder error")
            }
            
            if let placeMarks = _placeMarks {
                
                let placeMark = placeMarks[0]
                
                
                let ann = MKPointAnnotation()
                ann.title = self.parkName
                ann.subtitle = "經度:\(placeMark.location!.coordinate.latitude)" + "緯度:\(placeMark.location!.coordinate.longitude)"
                ann.coordinate = (placeMark.location?.coordinate)!
                self.map.showAnnotations([ann], animated: true)
                self.map.selectAnnotation(ann, animated: true)
                
            }
        }
    }
    
}
