//
//  DetailAcaraController.swift
//  acara.in
//
//  Created by Fathoni Adi Kurniawan on 01/12/17.
//  Copyright © 2017 Fathoni Adi Kurniawan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailAcaraController: UIViewController {
    
    
    @IBOutlet var namaacara_textfield: UITextField!
    @IBOutlet var tanggal_textfield: UITextField!
    @IBOutlet var kategori_textfield: UITextField!
    @IBOutlet var deskripsi_textview: UITextView!
    let datePicker = UIDatePicker()
    
    
    let session = UserDefaults.standard
    var categories: Array<Any> = []
    
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
        createDatePicker()
        let location = self.getSessionDictByKey(withKey: "lokasi_acara")!
        let longitude = location["longitude"]
        let latitude = location["latitude"]
        let urlString = Config.url()+"api/v1/category"
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
                        print(json["categories"])
                        let categories_db = json["categories"] as! [Any]
                        print(categories_db)
                        for category in (0..<categories_db.count)
                        {
                            if let data = categories_db[category] as? [String:Any]
                            {
                                self.categories.append(data["name"]!)
                            }
                        }
                    }
                    
                    print(self.categories)
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
        }

        
        //latitude_label.text = latitude?.description
        //longitude_label.text = longitude?.description
        
        // Do any additional setup after loading the view.
    }
    
    func createDatePicker()
    {
        toolbar.sizeToFit()
        let done_button = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDatePickerClick))
        toolbar.setItems([done_button], animated: false)
        
        tanggal_textfield.inputAccessoryView = toolbar
        tanggal_textfield.inputView = datePicker
        
        datePicker.datePickerMode = .date
        
    }
    
    
    
    
    @objc func doneDatePickerClick()
    {
        let formater = DateFormatter()
        formater.dateStyle = .medium
        formater.timeStyle = .none
        
        let date_selected = formater.string(from: datePicker.date)
        
        tanggal_textfield.text = date_selected as! String
        self.view.endEditing(true)
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
