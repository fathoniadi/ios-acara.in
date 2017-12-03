//
//  DetailAcaraController.swift
//  acara.in
//
//  Created by Fathoni Adi Kurniawan on 01/12/17.
//  Copyright © 2017 Fathoni Adi Kurniawan. All rights reserved.
//

import UIKit

class DetailAcaraController: UIViewController {

    @IBOutlet var latitude_label: UILabel!
    @IBOutlet var longitude_label: UILabel!
    
    let session = UserDefaults.standard
    
    func getSessionDictByKey(withKey key:String) -> [String:Float]?
    {
        guard let data = session.object(forKey: key) else {
            return nil
        }
        
        // Check if retrieved data has correct type
        guard let retrievedData = data as? Data else {
            return nil
        }
        
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(with: retrievedData)
        return unarchivedObject as? [String:Float]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = self.getSessionDictByKey(withKey: "lokasi_acara")!
        let longitude = location["longitude"]
        let latitude = location["latitude"]
        print(location)
        latitude_label.text = latitude?.description
        longitude_label.text = longitude?.description
        
        // Do any additional setup after loading the view.
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
