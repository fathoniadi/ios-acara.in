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

class RuteAcaraController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    let session = UserDefaults.standard
     var locationManager = CLLocationManager()
    
    @IBOutlet var viewer2: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: -7.2821281, longitude: 112.7929391, zoom: 16.0)
        viewer2.camera = camera
        
        viewer2.isMyLocationEnabled = true
        viewer2.settings.myLocationButton = true
        viewer2.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 16.0)
        viewer2.camera = camera
        viewer2.animate(to: camera)
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
