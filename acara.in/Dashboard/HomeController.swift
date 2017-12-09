//
//  HomeController.swift
//  acara.in
//
//  Created by Fathoni Adi Kurniawan on 27/11/17.
//  Copyright © 2017 Fathoni Adi Kurniawan. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire

class HomeController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBAction func tambah_acara_button(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "add_acara_sogue", sender: self)
    }
    var locationManager = CLLocationManager()
    
    var markers = [Any]()
    
    @IBOutlet var viewer2: GMSMapView!
    
    
    @IBAction func menu_button(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "menu_sogue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 13.0)
        viewer2.camera = camera
        
        viewer2.isMyLocationEnabled = true
        viewer2.settings.myLocationButton = true
        viewer2.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        loadMarker()
        

        // Do any additional setup after loading the view.
    }
    
    func delAllMarker()
    {
        for data in (0..<markers.count)
        {
            let marker = markers[data]
            if var value = marker as? [String:Any]
            {
                value["marker"] = nil
            }
        }
        markers.removeAll()
    }
    
    func loadMarker()
    {
        delAllMarker()
        let urlString = Config.url()+"api/v1/acara"
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
                        let acaras_db = json["acaras"] as! [Any]
                        print(acaras_db)
                        for acara in (0..<acaras_db.count)
                        {
                            if let data = acaras_db[acara] as? [String:Any]
                            {
                                let marker_acara = GMSMarker();
                                let latitude = Double(data["latitude"] as! String)!
                                let longitude = Double(data["longitude"] as! String)!
                                
                                marker_acara.title = data["name"] as? String
                                marker_acara.snippet = "Klik untuk lihat detail"
                                marker_acara.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                marker_acara.map = self.viewer2
                                self.markers.append(["data": data, "marker": marker_acara])
                            }
                        }
                        
                    }
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 13.0)
        viewer2.camera = camera
        viewer2.animate(to: camera)
        loadMarker()
        self.locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        var flag = false
        for marker_db in markers{
            if let data = marker_db as? [String:Any]
            {
                if(data["marker"] as! GMSMarker == marker)
                {
                    flag = true
                    
                    if let acara = data["data"] as? [String:Any]
                    {
                        let alert = UIAlertController(title: "Alert", message: acara["name"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    break
                }
            }
        }
        
        if(!flag)
        {
            let alert = UIAlertController(title: "Alert", message: "Data tidak ditemukan", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    

    @IBAction func returned(segue: UIStoryboardSegue) {
       
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
