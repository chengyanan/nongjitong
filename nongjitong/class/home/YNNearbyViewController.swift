//
//  YNNearbyViewController.swift
//  2015-08-06
//
//  Created by 农盟 on 15/8/6.
//  Copyright (c) 2015年 农盟. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class YNNearbyViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, YNNearByQuestionViewDelegate {

    let kAccuracy = 0.01
    
    let kLatitudeDelta = 0.0142737102703023
    let kLongitudeDelta = 0.0122213804488638
    let tableViewHeight: CGFloat = 44
    let itemSpacing: CGFloat = 6
    
    // 当前选中的Id
    var classId: String = "0"
    
    lazy var titleView: YNNearbyTitleView = {
    
    return YNNearbyTitleView(frame: CGRectMake(self.view.frame.size.width/2, 20, 156, 44))
    
    }()
    
    lazy var myselfLocationButton: UIButton = {
    
        var tempView = UIButton()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return tempView
    }()
    
    lazy var locationManger: CLLocationManager = {
        let tempLocationManager = CLLocationManager()
        tempLocationManager.pausesLocationUpdatesAutomatically = true
        tempLocationManager.delegate = self
        tempLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        tempLocationManager.distanceFilter = 10
        return tempLocationManager
        }()
    
    lazy var geocder: CLGeocoder = {
        return CLGeocoder()
        }()
    
    lazy var mapView: MKMapView = {
        let tempMapView = MKMapView(frame: self.view.bounds)
        tempMapView.mapType = MKMapType.Standard
        tempMapView.showsUserLocation = true
        tempMapView.userTrackingMode = MKUserTrackingMode.Follow
        tempMapView.delegate = self
        return tempMapView
        }()
    
    var collectionView: UICollectionView?
    var nearByQuestionView: YNNearByQuestionView?
    
    var coordinate: CLLocationCoordinate2D? {
        
        didSet {
        
            if isLoadData {
                
                self.updateUserLocation()
           
                self.getNearUserPositionFromServer(nil)
                
                self.nearByQuestionView?.coordinate = coordinate
            }
            
        }
       
    }
    
    var callOutAnnotationView: YNCallOutAnnotationView?
    var callOutAnnotation: YNCallOutAnnotation?
    
    var callOutAnnotationViewCurrent: YNCallOutAnnotationView?
    var callOutAnnotationCurrent: YNCallOutAnnotation?
    
    var isLocated:Bool = false//是否是第一次定位
    var isDeleteAnnotation: Bool = false//是否要删除当前界面上的calloutView
    var isLoadData: Bool = true//知道当前数据加载完毕,才能重新加载数据,防止用户快速移动的时候,不停的发送请求
    var currentDataIndex:Int? = -1
    
    lazy var baseAnnocationArray: NSMutableArray? = {
        
        return NSMutableArray()
        }()
    
    var dataArray = [YNNearByModel]()
    
    //collectionViewdatasource
    var selectedArray = [YNSelectedProductModel]() {
    
        didSet {

            self.collectionView?.reloadData()
            self.collectionView?.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .None)
        }
    
    }
    
    var collectionViewLeftRightInset: CGFloat {
    
        var temp: CGFloat = 0
        var margin: CGFloat = 0
        
        if self.selectedArray.count > 0 {
        
            for item in self.selectedArray {
        
                let width = widthForView(item.class_name, font: UIFont.systemFontOfSize(17))
                
                temp += width + 12
            }
            
            let distant = self.view.frame.size.width - 15*2 - temp
            
            if  distant > 0 {
            
                margin = (self.view.frame.size.width - temp) * 0.5
                
            } else {
            
                margin = 15
            }
            
        }
        
        return margin
    }
    
    var rightItem: UIBarButtonItem?
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLocate()
        
        self.view.addSubview(self.mapView)
        self.navigationItem.titleView = self.titleView
    
        var tempArray = [YNSelectedProductModel]()
        let model0 = YNSelectedProductModel(id: "0", name: "全部")
        model0.isSelected = true
        let model1 = YNSelectedProductModel(id: "1", name: "生产者")
        let model2 = YNSelectedProductModel(id: "2", name: "农资人")
        let model3 = YNSelectedProductModel(id: "3", name: "经纪人")
        tempArray.append(model0)
        tempArray.append(model1)
        tempArray.append(model2)
        tempArray.append(model3)
        
        self.selectedArray = tempArray
    
        setInterface()
        
        
        self.rightItem = UIBarButtonItem(title: "登录", style: .Plain, target: self, action: "login")
        navigationItem.rightBarButtonItem = rightItem
    }
    
    func login() {
        
        //没有登录 跳登录界面
        let signInVc = YNSignInViewController()
        
        let navVc = UINavigationController(rootViewController: signInVc)
        
        self.presentViewController(navVc, animated: true, completion: { () -> Void in
            
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let uesrId = kUser_ID()
        
        if let _ = uesrId {
            
            navigationItem.rightBarButtonItem = nil
            
            if let _ = self.coordinate {
                
                self.nearByQuestionView?.coordinate = self.coordinate
            }
            
            
        } else {
            
            
            navigationItem.rightBarButtonItem = self.rightItem
        }
        

        
    }
    
    func setInterface() {
    
        //collectionView
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = itemSpacing
        flow.sectionInset = UIEdgeInsets(top: 0, left: collectionViewLeftRightInset, bottom: 0, right: collectionViewLeftRightInset)
        flow.scrollDirection = .Horizontal
        
        let tempCollectionView = UICollectionView(frame: CGRectMake(0, 64, self.view.frame.size.width, 44), collectionViewLayout: flow)
        tempCollectionView.delegate = self
        tempCollectionView.dataSource = self
        tempCollectionView.backgroundColor = kRGBA(244, g: 244, b: 244, a: 0.8)
        
        tempCollectionView.registerClass(YNQuestionCollectionViewCell.self, forCellWithReuseIdentifier: "Cell_Collection_Question_List")
        tempCollectionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(tempCollectionView)
        self.collectionView = tempCollectionView
        //默认选中第一个
        self.collectionView?.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .None)
        
        //nearByQuestionView
        let tempView = YNNearByQuestionView()
        let leftMargin: CGFloat = 10
        let bottomMargin: CGFloat = 8
        var height: CGFloat = 120
        
        if kIS_iPhone6Above() {
        
            height = 150
        }
        
        let y = self.view.frame.size.height - bottomMargin - height - 49
        let width = self.view.frame.size.width - leftMargin*2
        tempView.frame = CGRectMake(leftMargin, y, width, height)
        tempView.delegate = self
        self.view.addSubview(tempView)
        self.nearByQuestionView = tempView
        
        //addQuestionButton
        let button = UIButton()
        button.setImage(UIImage(named: "addNewNearQuestion"), forState: .Normal)
        button.bounds = CGRectMake(0, 0, 49, 49)
        let buttonX = self.view.frame.size.width - 30 - 12
        let buttonY = y + height * 0.5
        button.center = CGPointMake(buttonX, buttonY)
        button.addTarget(self, action: "askQuestionButtonClick", forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
        
    }
    
    //MARK: event response
    
    func askQuestionButtonClick() {
    
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let askVc = mainStoryBoard.instantiateViewControllerWithIdentifier("SB_AskquestionVc") as! YNAskQuestionViewController
        askVc.isOfflineQuestion = true
        
        self.navigationController?.pushViewController(askVc, animated: true)
    }
    
    @IBAction func leftBarButtonClicke(sender: AnyObject) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        let settingVc = storyBoard.instantiateViewControllerWithIdentifier("SB_Setting")
        
        self.navigationController?.pushViewController(settingVc, animated: true)
    }
   
    func updateUserLocation() {
    
        if let userId = kUser_ID() as? String {
        
            //登陆了更新
            let params: [String: String?] = ["m": "Appapi",
                "key": "KSECE20XE15DKIEX3",
                "c": "UserPosition",
                "a": "updatePosition",
                "user_id": userId,
                "longitude":String(coordinate!.longitude),
                "latitude": String(coordinate!.latitude)
            ]
            
            YNHttpNearBy().updatePositionWithParam(params, successFull: { (json) -> Void in
                
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        print("用户位置更新成功")
                        
                    } else if status == 0 {
                        
                        
                        if let msg = json["msg"] as? String {
                            
                            YNProgressHUD().showText(msg, toView: self.view)
                            print("用户位置更新失败: \(msg)")
                        }
                    }
                    
                }
                
                
                }, failureFul: { (error) -> Void in
                    
                    
                    YNProgressHUD().showText("数据加载失败", toView: self.view)
            })
        
        } else {
        
            //没登录不用更新
        }
        
    }
    
    //MARK: - get data from server
    func getNearUserPositionFromServer(role: String?) {

        if let _ = self.coordinate {
        
            let params: [String: String?] = ["m": "Appapi",
                "key": "KSECE20XE15DKIEX3",
                "c": "UserPosition",
                "a": "nearUser",
                "user_id": nil,
                "longitude": String(coordinate!.longitude),
                "latitude": String(coordinate!.latitude),
                "role": role
            ]
            
            self.titleView.start()
            
            YNHttpNearBy().nearUserPositionWithParam(params, successFull: { (json) -> Void in
                
                self.titleView.end()
                self.isLoadData = false
                
//                print("data - \(json)\n")
                
                if let status = json["status"] as? Int {
                    
                    self.showMyLocation(self.coordinate!)
                    
                    if status == 1 {
                        
                        if let tempArray = json["data"] as? NSArray {
                            
                            
                            self.dataProcessing(tempArray)
                            
                        } else {
                            
                            YNProgressHUD().showText("数组不存在,此地区没有数据", toView: self.view)
                            
                            
                        }
                        
                        
                    } else if status == 0 {
                        
                        self.isLoadData = true
                        
                        if let msg = json["msg"] as? String {
                            
                            YNProgressHUD().showText(msg, toView: self.view)
                        }
                        
                    }
                    
                }
                
                
                
                }) { (error) -> Void in
                    
                    self.titleView.end()
                    YNProgressHUD().showText("请求失败,请检查网络", toView: self.view)
                    self.isLoadData = true
                    
            }
            
            
        } else {
        
            print("无法加载附近数据")
        }
       
        
    }
    
    func dataProcessing(dataArray: NSArray) {
   
        if dataArray.count > 0 {
            
            self.dataArray.removeAll()
       
            for restaurant in dataArray {
                
                let tempRestaurant = YNNearByModel(dict: restaurant as! NSDictionary)
                self.dataArray.append(tempRestaurant)
                
            }
            
             addEnterpriseAnnotation()
            
        } else {
       
            self.dataArray.removeAll()
            let tempArray = NSArray(array: self.baseAnnocationArray!)
            self.mapView.removeAnnotations(tempArray as! [MKAnnotation])
            self.baseAnnocationArray?.removeAllObjects()
            
            YNProgressHUD().showText("此地区没有数据", toView: self.view)
        }
        
    }
    
    
    //MARK: - custom method
    func startLocate() {
   
        let locationServicesEnabled: Bool = CLLocationManager.locationServicesEnabled()
        if locationServicesEnabled {
       
            let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            if status == CLAuthorizationStatus.NotDetermined {
               
                if #available(iOS 8.0, *) {
                    
                    self.locationManger.requestAlwaysAuthorization()
                    self.locationManger.requestWhenInUseAuthorization()
                } else {
                        // Fallback on earlier versions
                }
            }
            
            self.locationManger.startUpdatingLocation()
            
        } else {
       
            YNProgressHUD().showText("该设备无法定位", toView: self.view)
        }
    }
    
    func showMyLocation(coordinate: CLLocationCoordinate2D) {
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(kLatitudeDelta, kLongitudeDelta)
        let regin: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        self.mapView.setRegion(regin, animated: true)
    }
    
    func addEnterpriseAnnotation() {
        
        let tempArray = NSArray(array: self.baseAnnocationArray!)
        self.mapView.removeAnnotations(tempArray as! [MKAnnotation])
        self.baseAnnocationArray?.removeAllObjects()
        
        for var index = 0; index < self.dataArray.count; ++index {
       
            let model: YNNearByModel = self.dataArray[index]
            let baseAnnotation: YNBaseAnnotation = YNBaseAnnotation(coordinate: model.coordinate!)
            baseAnnotation.index = index
            self.mapView.addAnnotation(baseAnnotation)
            self.baseAnnocationArray?.addObject(baseAnnotation)
        }
        
        self.isLoadData = true
        
    }
    
    func isUpdateLocation(currentLocation: CLLocationCoordinate2D, userLocation: CLLocationCoordinate2D)-> Bool {
   
        let latitude: Double = currentLocation.latitude - userLocation.latitude
        let longitude: Double = currentLocation.longitude - userLocation.longitude
        
        let absoluteValueOfLatitude = fabs(latitude)
        let absoluteValueOfLongitude = fabs(longitude)
        
//        let latitudeSatify: Bool = latitude > kAccuracy || latitude < -kAccuracy
//        let longitudeSatify: Bool = longitude > kAccuracy || longitude < -kAccuracy
        
        let latitudeSatify: Bool = absoluteValueOfLatitude > kAccuracy
        
        let longitudeSatify: Bool = absoluteValueOfLongitude > kAccuracy
        
    
        if latitudeSatify || longitudeSatify {
       
            return true
        }
        
        return false
        
    }
    
    func reverseGeocodeLocationWithUserLocation(userLocation: MKUserLocation!) {
   
        //解析地址
        self.geocder.reverseGeocodeLocation(userLocation.location!, completionHandler: { (placemarks, error) -> Void in
            
            if let _ = placemarks {
           
                 let placeMark: CLPlacemark = placemarks!.first!
                
                    if let thoroughfare = placeMark.thoroughfare {
                        
                        var title: String = thoroughfare
                        
                        if let subThoroughfare = placeMark.subThoroughfare {
                            
                            title += subThoroughfare
                        }
                        
                        userLocation.title = title
                    }
                    
                }
            
            
        })
        
        if !self.isLocated {
            
            showMyLocation(userLocation.location!.coordinate)
            self.isLocated = true
            
        }
    }
    
//MARK: - MKMapViewDelegate
    func mapViewWillStartLocatingUser(mapView: MKMapView) {
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .NotDetermined {
        
            print("Requesting when in use auth");
            if #available(iOS 8.0, *) {
                self.locationManger.requestWhenInUseAuthorization()
                self.locationManger.requestAlwaysAuthorization()
            } else {
                // Fallback on earlier versions
            }
            
        } else if status == .Denied {
        
            print("Location services denied")
        }
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        
        if let _ = self.coordinate {
            
            let isUpdateLocation = self.isUpdateLocation(self.coordinate!, userLocation: userLocation.coordinate)
        
            if isUpdateLocation {
           
                //新位置和以前不一样，设置新位置，从新加载数据
                self.coordinate = userLocation.location!.coordinate
                reverseGeocodeLocationWithUserLocation(userLocation)
            
            } else {
            
                //不是新位置 什么也不做
            }
            
        }else {
       
            self.coordinate = userLocation.location!.coordinate
            reverseGeocodeLocationWithUserLocation(userLocation)
        }
        
        
//        self.coordinate = userLocation.location!.coordinate
//        reverseGeocodeLocationWithUserLocation(userLocation)
        
        //TODO:保存位置
        
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is YNBaseAnnotation {
       
            let identify = "PINANNOTATIONVIEW"
            var pinAnnotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(identify) as? MKPinAnnotationView
            if pinAnnotationView == nil {
                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identify)
                
            }
            
            pinAnnotationView?.canShowCallout = false
            pinAnnotationView?.pinColor = MKPinAnnotationColor.Purple
            return pinAnnotationView
            
        } else if annotation is YNCallOutAnnotation {
       
            let callOutidentify = "CALLOUTANNOTATIONVIEW"
            var callOutAnnotationView: YNCallOutAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(callOutidentify) as? YNCallOutAnnotationView
            if callOutAnnotationView == nil {
                
                callOutAnnotationView = YNCallOutAnnotationView(annotation: annotation, reuseIdentifier: callOutidentify)
                
            } else {
                
                //如果没有重新生成的话 就要删掉
                if let tempSubViews = callOutAnnotationView?.contentView.subviews {
               
                    for item in tempSubViews {
                   
                        item.removeFromSuperview()
                    }
                }
                
            }
            
            callOutAnnotationView!.alpha = 1.0
            
            if let _ = self.callOutAnnotationCurrent {
           
                self.callOutAnnotationViewCurrent = callOutAnnotationView
                
            } else {
                
                self.callOutAnnotationView = callOutAnnotationView
                
            }
            
            
            let contentView:YNCalloutContentView = YNCalloutContentView(frame: callOutAnnotationView!.contentView.bounds)
            
            contentView.dataModel = self.dataArray[self.currentDataIndex!]
            
            callOutAnnotationView?.contentView.addSubview(contentView)
            
            return callOutAnnotationView
        }
        
        
        return nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if view.annotation is YNBaseAnnotation {
       
//            self.isDeleteAnnotation = false
            
            let baseAnnotation: YNBaseAnnotation = view.annotation as! YNBaseAnnotation
            
            self.currentDataIndex = baseAnnotation.index
            
            let callOutAnnotation = YNCallOutAnnotation(coordinate: view.annotation!.coordinate)
            mapView.addAnnotation(callOutAnnotation)
           callOutAnnotation.index = baseAnnotation.index
            
            if let _ = self.callOutAnnotation {
           
                self.callOutAnnotationCurrent = callOutAnnotation
            } else {
           
                self.callOutAnnotation = callOutAnnotation
            }
            
            
            
        } else if view.annotation is YNCallOutAnnotation {
            
            //进入个人主页界面
            let tempCallOutAnnotation = view.annotation as? YNCallOutAnnotation
            
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let introduceVc = mainStoryBoard.instantiateViewControllerWithIdentifier("SB_User_introduce") as? YNUserIntroduceViewController
            introduceVc?.model = self.dataArray[tempCallOutAnnotation!.index!]
            
            self.navigationController?.pushViewController(introduceVc!, animated: true)


        }
        
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        
        if let _ = self.callOutAnnotation {
            
//            self.isDeleteAnnotation = true
            
            UIView.animateWithDuration(0.2 , animations: { () -> Void in
                
                self.callOutAnnotationView!.alpha = 0.0
                
            }, completion: { (finished) -> Void in
                
                if let _ = self.callOutAnnotation {
                
                    self.mapView.removeAnnotation(self.callOutAnnotation!)
                    self.callOutAnnotation = nil
                }
                
               
                
//                if self.isDeleteAnnotation {
//               
//                    self.mapView.removeAnnotation(self.callOutAnnotation)
//                    self.callOutAnnotation = nil
//                }

            })
            
        } else if let _ = self.callOutAnnotationCurrent {
       
            UIView.animateWithDuration(0.3 , animations: { () -> Void in
                
                self.callOutAnnotationViewCurrent!.alpha = 0.0
                
                }, completion: { (finished) -> Void in
                    
                    
                    self.mapView.removeAnnotation(self.callOutAnnotationCurrent!)
                    self.callOutAnnotationCurrent = nil
                    
            })

        }
        
       
    }
    
//    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
//        
//       print("\n\(mapView.region.span.latitudeDelta), \(mapView.region.span.longitudeDelta)\n")
//    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        if let location = locations.last {
//            
//            let locationTool = Location()
//            
//            let coorinate = locationTool.transformFromWGSToGCJ(location.coordinate)
//            
//            let span = MKCoordinateSpanMake(0.011, 0.0089)
//            
//            let region = MKCoordinateRegionMake(coorinate, span)
//            
//            self.mapView.setRegion(region, animated: true)
//        }
//        
//        self.locationManger.stopUpdatingLocation()
        
    }
    
    
    
    //MARK:UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if selectedArray.count > 0 {
            
            return selectedArray.count
        }
        
        return 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identify = "Cell_Collection_Question_List"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as! YNQuestionCollectionViewCell
        cell.productModel = selectedArray[indexPath.item]
        
        return cell
        
    }
    
    //MARK:UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let model = selectedArray[indexPath.item]
        let width = widthForView(model.class_name, font: UIFont.systemFontOfSize(17))
        
        return CGSize(width: width + 12, height: tableViewHeight - 1)
        
    }
    
    func widthForView(text:String, font:UIFont) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, CGFloat.max, CGFloat.max))
        label.numberOfLines = 1
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.width
    }
    
    //MARK: collectionView delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let model = self.selectedArray[indexPath.row]
        model.isSelected = true
        
        self.classId = model.class_id!
        
        //加载新数据
        self.getNearUserPositionFromServer(model.class_id)
        
        collectionView.reloadItemsAtIndexPaths([indexPath])
        collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.None)
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let model = self.selectedArray[indexPath.row]
        model.isSelected = false
        
        collectionView.reloadItemsAtIndexPaths([indexPath])
    }
    
    //MARK: YNNearByQuestionViewDelegate
    func nearByQuestionViewDidSelectedRow() {
        
        let offlineQuestionvc = YNOfflineQuestionListViewController()
        self.navigationController?.pushViewController(offlineQuestionvc, animated: true)
        
    }
    
}
