//
//  AddAcaraController.swift
//  acara.in
//
//  Created by Fathoni Adi Kurniawan on 28/11/17.
//  Copyright © 2017 Fathoni Adi Kurniawan. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class AddAcaraController: UIViewController, CLLocationManagerDelegate {

 

    //@IBOutlet var viewer2: GMSMapView!
    @IBOutlet fileprivate var viewer2: GMSMapView!
    var locationManager = CLLocationManager()
    var mapView = GMSMapView()
    
   // @IBOutlet weak var add_acara_nav: UINavigationItem!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 13.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        //view.addSubview(viewer2)
        //viewer2 = self.mapView
        viewer2.camera = camera
        
        viewer2.isMyLocationEnabled = true
        viewer2.settings.myLocationButton = true
        
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
    

}
