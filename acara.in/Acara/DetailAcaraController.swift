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

class DetailAcaraController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var namaacara_textfield: UITextField!
    @IBOutlet var tanggal_textfield: UITextField!
    @IBOutlet var kategori_textfield: UITextField!
    @IBOutlet var deskripsi_textview: UITextView!
    let datePicker = UIDatePicker()
    let toolbar_datepicker = UIToolbar()
    let toolbar_kategoripicker = UIToolbar()
    let kategoriPicker = UIPickerView()
    
    let session = UserDefaults.standard
    var categories: Array<Any> = []
    
    
    @IBAction func simpan_button(_ sender: UIBarButtonItem) {
        let nama_acara = namaacara_textfield.text!
        let tanggal_acara = tanggal_textfield.text!
        let kategori_acara = kategori_textfield.text!
        let deskripsi_acara = deskripsi_textview.text!
        let token = self.session.string(forKey: "token")!
        let location = self.getSessionDictByKey(withKey: "lokasi_acara")!
        let longitude = location["longitude"]
        let latitude = location["latitude"]
        
        let parameters:[String:String] = [
            "name": nama_acara,
            "description": deskripsi_acara,
            "date": tanggal_acara,
            "category": kategori_acara,
            "token": token,
            "longitude": (longitude?.description)!,
            "latitude": (latitude?.description)!,
        ]
        
        //print(parameters)
        
        let urlString = Config.url()+"api/v1/acara"
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseJSON { response in
                //print("Request: \(String(describing: response.request))")   // original url request
                //print("Response: \(String(describing: response.response))") // http url response
                //print("Result: \(response.result)")                         // response serialization result
                
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                    let alert = UIAlertController(title: "Gagal Menyimpan Data", message: "Cannot connect to the server", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    return self.present(alert, animated: true, completion: nil)
                }
                
                if let json = response.result.value as? [String:Any] {
                    let status = json["status"] as! Int
                    //print(status)
                    if( Int(status) == 200)
                    {
                        let alert = UIAlertController(title: "Berhasil", message: "Berhasil Menyimpan Data Acara Baru", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:  { (action: UIAlertAction!) in
                            self.performSegue(withIdentifier: "to_init_segue", sender: nil)
                        }))

                        return self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                        let message = json["message"] as! String
                        let alert = UIAlertController(title: "Gagal", message: message, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        return self.present(alert, animated: true, completion: nil)
                    }
                    
                    
                    
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    //print("Data: \(utf8Text)") // original server data as UTF8 string
                }
        }
        
        
    }
    
    func getSessionDictByKey(withKey key:String) -> [String:String]?
    {
        guard let data = session.object(forKey: key) else {
            return nil
        }
        
        // Check if retrieved data has correct type
        guard let retrievedData = data as? Data else {
            return nil
        }
        
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(with: retrievedData)
        return unarchivedObject as? [String:String]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createToolbarDatePicker()
        createDatePicker()
        createKategoriPicker()
        
        deskripsi_textview.layer.borderWidth = 1.0
        deskripsi_textview.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        //let location = self.getSessionDictByKey(withKey: "lokasi_acara")!
        //let longitude = location["longitude"]
        //let latitude = location["latitude"]
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
                        //print(json["categories"])
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
                    self.kategoriPicker.reloadAllComponents()
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
        }
    }
    
    func createToolbarDatePicker()
    {
        toolbar_datepicker.sizeToFit()
        let done_datepicker = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDatePickerClick))
        toolbar_datepicker.setItems([done_datepicker], animated: false)
        
        toolbar_kategoripicker.sizeToFit()
        let done_kategoripicker = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneKategoriPickerClick))
        toolbar_kategoripicker.setItems([done_kategoripicker], animated: false)
    }
    
    func createDatePicker()
    {
        tanggal_textfield.inputAccessoryView = toolbar_datepicker
        tanggal_textfield.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    func createKategoriPicker()
    {
        kategoriPicker.delegate = self
        kategoriPicker.dataSource = self

        kategori_textfield.inputAccessoryView = toolbar_kategoripicker
        kategori_textfield.inputView = kategoriPicker
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.kategori_textfield.text = categories[row] as? String
    }
    
    
    @objc func doneDatePickerClick()
    {
        let formater = DateFormatter()
        formater.dateStyle = .medium
        formater.timeStyle = .none
        formater.dateFormat = "MM/dd/YYYY"
        
        let date_selected = formater.string(from: datePicker.date)
        
        tanggal_textfield.text = date_selected
        self.view.endEditing(true)
    }
    
    @objc func doneKategoriPickerClick()
    {
       kategori_textfield.resignFirstResponder()
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
