//
//  RuteAcaraController.swift
//  acara.in
//
//  Created by Fathoni Adi Kurniawan on 10/12/17.
//  Copyright © 2017 Fathoni Adi Kurniawan. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

class RuteAcaraController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    let session = UserDefaults.standard
    var locationManager = CLLocationManager()
    var last_position = [String:String]()
    var acara_position = [String:String]()
    var polylines = [GMSPolyline]()
    
    @IBOutlet var viewer2: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        last_position["longitude"] = "-7.2821281".description
        last_position["latitude"] = "112.7929391".description
        
        let camera = GMSCameraPosition.camera(withLatitude: -7.2821281, longitude: 112.7929391, zoom: 16.0)
        viewer2.camera = camera
        
        viewer2.isMyLocationEnabled = true
        viewer2.settings.myLocationButton = true
        viewer2.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
        
        let acara_id = session.string(forKey: "acara_id")!;
        
        let urlString = Config.url()+"api/v1/acara/"+acara_id
        Alamofire.request(urlString, method: .get, encoding: URLEncoding.default)
            .validate()
            .responseJSON { response in
                //                print("Request: \(String(describing: response.request))")   // original url request
                //                print("Response: \(String(describing: response.response))") // http url response
                //                print("Result: \(response.result)")                         // response serialization result
                //
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                    return
                }
                
                if let json = response.result.value as? [String:Any] {
                    if(json["status"] as! Int == 200)
                    {
                        
                        if let data = json["data"] as? [String:Any]
                        {
                            let marker_acara = GMSMarker();
                            
                            self.acara_position["latitude"] = data["latitude"] as? String
                            self.acara_position["longitude"] = data["longitude"] as? String
                            
                            let latitude = Double(data["latitude"] as! String)!
                            let longitude = Double(data["longitude"] as! String)!
                            
                            marker_acara.title = data["name"] as? String
                            marker_acara.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            marker_acara.map = self.viewer2
                            self.viewer2.selectedMarker = marker_acara
                            self.drawPath()
                        }
                    }
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func removeDirection()
    {
        for polyline in polylines
        {
            polyline.map = nil
        }
        polylines.removeAll()
    }
    
    func drawPath()
    {
        if(acara_position.isEmpty || last_position.isEmpty)
        {
            return
        }
        
        removeDirection()
        let lat_orig = last_position["latitude"] as String!
        let long_orig = last_position["longitude"] as String!
        let dest_lat = acara_position["latitude"] as String!
        let dest_long = acara_position["longitude"] as String!
        let origin = lat_orig!+","+long_orig!
        let destination = dest_lat!+","+dest_long!
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&language=ID-id"
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            //print(response.response as Any) // HTTP URL response
            //print(response.data as Any)     // server data
            //print(response.result as Any)   // result of response serialization
            
            let json = JSON(response.result.value!)
            print(json)
            let routes = json["routes"].arrayValue
            
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.red
                polyline.map = self.viewer2
                self.polylines.append(polyline)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 16.0)
        viewer2.camera = camera
        viewer2.animate(to: camera)
        

        last_position["longitude"] = userLocation!.coordinate.longitude.description
        last_position["latitude"] = userLocation!.coordinate.latitude.description
            
        drawPath()
        self.locationManager.stopUpdatingLocation()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
