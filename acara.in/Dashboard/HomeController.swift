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

class HomeController: UIViewController, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    lazy var mapView = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 13.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        view = self.mapView
        
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        

        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 13.0)
        self.mapView.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
