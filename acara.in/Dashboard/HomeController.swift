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

class HomeController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBAction func tambah_acara_button(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "add_acara_sogue", sender: self)
    }
    var locationManager = CLLocationManager()
    lazy var mapView = GMSMapView()
    
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
        

        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 13.0)
        
        //        marker.position = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        //        marker.map = viewer2
        
        viewer2.camera = camera
        viewer2.animate(to: camera)
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
