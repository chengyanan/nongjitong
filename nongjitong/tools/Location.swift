//
//  Location.swift
//  2015-08-06
//
//  Created by 农盟 on 15/9/1.
//  Copyright (c) 2015年 农盟. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol LocationDelegate {

    func locationDidUpdateLocation(location: CLLocation)
}

class Location: NSObject, CLLocationManagerDelegate {
    
    //public protory
    var delegate: LocationDelegate?
    
    private let pi: Double = 3.14159265358979324
    private let ee: Double = 0.00669342162296594323
    private let a: Double = 6378245.0
    
    var cooridate: CLLocationCoordinate2D?
    
    func startLocation() {
   
        let locationServicesEnabled: Bool = CLLocationManager.locationServicesEnabled()
        if locationServicesEnabled {
       
            let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            
            if status == CLAuthorizationStatus.NotDetermined {
        
               
                if #available(iOS 8.0, *) {
                    
                    self.locationManager.requestWhenInUseAuthorization()
                    
                } else {
                    
                    // Fallback on earlier versions
                }
                
            }
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.distanceFilter = 10
            self.locationManager.startUpdatingLocation()
            
        } else {
       
            YNProgressHUD().showText("定位功能未开启", toView: UIApplication.sharedApplication().keyWindow!)
        }
    }
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation: CLLocation = locations[locations.startIndex] 
        
        cooridate = self.transformFromWGSToGCJ(newLocation.coordinate)
        
        let nowLocation = CLLocation(latitude: cooridate!.latitude, longitude: cooridate!.longitude)
        
        self.delegate?.locationDidUpdateLocation(nowLocation)
        
    }
    
    func transformFromWGSToGCJ(wgsLoc: CLLocationCoordinate2D)-> CLLocationCoordinate2D {
   
        var adjustLoc: CLLocationCoordinate2D?
        
        if self.isLocationOutOfChina(wgsLoc) {
            
            adjustLoc = wgsLoc
            
        } else {
       
            var adjustLat: Double = self.transformLatWithX(wgsLoc.longitude - 105.0, y: wgsLoc.latitude - 35.0)
            var adjustLon: Double = self.transformLonWithX(wgsLoc.longitude - 105.0, y: wgsLoc.latitude - 35.0)
            let radLat: Double = wgsLoc.latitude / 180.0 * pi
            var magic: Double = sin(radLat)
            magic = 1 - ee * magic * magic
            let sqrtMagic: Double = sqrt(magic)
            adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi)
            adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi)

            adjustLoc = CLLocationCoordinate2DMake(wgsLoc.latitude + adjustLat, wgsLoc.longitude + adjustLon)
            
        }
        
        return adjustLoc!
    }
    
    func isLocationOutOfChina(coordinate: CLLocationCoordinate2D)->Bool {
   
        if (coordinate.longitude < 72.004 || coordinate.longitude > 137.8347 || coordinate.latitude < 0.8293 || coordinate.latitude > 55.8271) {
       
            return true
        }
        
        return false
    }
    
    func transformLatWithX(x: Double, y: Double)->Double {
   
        let temp = 0.2 * sqrt(fabs(x))
        var lat: Double = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + temp
        lat += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0
        lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0
        
        lat += (160.0 * sin(y / 12.0 * pi) + 3320 * sin(y * pi / 30.0)) * 2.0 / 3.0
        
        return lat
    }
    
    func transformLonWithX(x: Double, y: Double)->Double {
        
        let temp = 0.1 * sqrt(fabs(x))
        var lon: Double = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + temp
        
        lon += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0
        lon += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0
        lon += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0
        return lon
        
    }
    
    
    private lazy var locationManager: CLLocationManager = {
        
        var tempLm: CLLocationManager = CLLocationManager()
        tempLm.pausesLocationUpdatesAutomatically = true
        return tempLm
        
    }()
    
    //MARK: 解析地址
    func geocoderAddress(location: CLLocation, success:(placemarks: [CLPlacemark]?)->Void, failure: (error: NSError?)->Void) {
        
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            
            if let temp = error {
                
               failure(error: temp)
                
            } else {
            
                
                success(placemarks: placemarks)
                
////                print(placemarks)
//                
//                if let _ = placemarks {
//                    
//                    let placeMark: CLPlacemark = placemarks!.first!
//                    
//                    //常用的
//                    print(placeMark.name)//名字, 比如古德佳苑
//                    print(placeMark.thoroughfare)//农业路
//                    print(placeMark.subThoroughfare)
//                    print(placeMark.subLocality)//区, 比如金水区
//                    print(placeMark.locality)//市, 比如郑州市
//                    print(placeMark.administrativeArea)//省, 比如河南省
//                    print(placeMark.country)//国家: 比如中国
//                    
//                    //不常用
//                    print(placeMark.subAdministrativeArea)
//                    print(placeMark.postalCode)
//                    print(placeMark.ISOcountryCode)//国家代号：中国为CN
//                    print(placeMark.inlandWater)
//                    print(placeMark.ocean)
//                    print(placeMark.areasOfInterest)
//                    
//                }

                
            }
            
            
        }
        
    }
    
    
    
    
    
}