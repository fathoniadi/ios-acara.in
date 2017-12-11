//
//  PencarianController.swift
//  acara.in
//
//  Created by Fathoni Adi Kurniawan on 11/12/17.
//  Copyright © 2017 Fathoni Adi Kurniawan. All rights reserved.
//

import UIKit
import Alamofire

class PencarianController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var keyword_textfield: UITextField!
    @IBOutlet var kategori_textfield: UITextField!
    
    @IBOutlet var datestart_textfield: UITextField!
    @IBOutlet var dateend_textfield: UITextField!
    
    let session = UserDefaults.standard
    
    let datestart_datepicker = UIDatePicker()
    let dateend_datepicker = UIDatePicker()
    let kategoriPicker = UIPickerView()
    
    let datestart_toolbar = UIToolbar()
    let dateend_toolbar = UIToolbar()
    let kategori_toolbar = UIToolbar()
    
    var categories: Array<Any> = []
    @IBAction func cari_button(_ sender: UIBarButtonItem) {
        let kategori = kategori_textfield.text!
        let keyword = keyword_textfield.text!
        let jarak = jarakmaks_textfield.text!
        let date_start = datestart_textfield.text!
        let date_end = dateend_textfield.text!
        
        let parameters = [
            "kategori" : kategori,
            "keyword": keyword,
            "jarak": jarak,
            "date_start": date_start,
            "date_end": date_end
        ]
        
        let dict = NSKeyedArchiver.archivedData(withRootObject: parameters)
        
        session.set(dict, forKey: "pencarian")
        self.performSegue(withIdentifier: "to_init_segue", sender: nil)
    }
    
    @IBOutlet var jarakmaks_textfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createToolbar()
        createKategoriPicker()
        createDatePicker()

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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createToolbar()
    {
        kategori_toolbar.sizeToFit()
        let done_kategoripicker = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneKategoriPickerClick))
        kategori_toolbar.setItems([done_kategoripicker], animated: false)
        
        datestart_toolbar.sizeToFit()
        let done_datestartpicker = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDateStartPickerClick))
        datestart_toolbar.setItems([done_datestartpicker], animated: false)
        
        dateend_toolbar.sizeToFit()
        let done_dateendpicker = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDateEndPickerClick))
        dateend_toolbar.setItems([done_dateendpicker], animated: false)
    }
    
    @objc func doneDateEndPickerClick()
    {
        let formater = DateFormatter()
        formater.dateStyle = .medium
        formater.timeStyle = .none
        formater.dateFormat = "MM/dd/YYYY"
        
        let date_selected = formater.string(from: dateend_datepicker.date)
        
        dateend_textfield.text = date_selected
        self.view.endEditing(true)
    }
    
    @objc func doneDateStartPickerClick()
    {
        let formater = DateFormatter()
        formater.dateStyle = .medium
        formater.timeStyle = .none
        formater.dateFormat = "MM/dd/YYYY"
        
        let date_selected = formater.string(from: datestart_datepicker.date)
        
        datestart_textfield.text = date_selected
        self.view.endEditing(true)
    }
    
    
    
    @objc func doneKategoriPickerClick()
    {
        kategori_textfield.resignFirstResponder()
    }
    
    func createKategoriPicker()
    {
        kategoriPicker.delegate = self
        kategoriPicker.dataSource = self
        
        kategori_textfield.inputAccessoryView = kategori_toolbar
        kategori_textfield.inputView = kategoriPicker
    }
    
    func createDatePicker()
    {
        datestart_textfield.inputAccessoryView = datestart_toolbar
        datestart_textfield.inputView = datestart_datepicker
        datestart_datepicker.datePickerMode = .date
        
        dateend_textfield.inputAccessoryView = dateend_toolbar
        dateend_textfield.inputView = dateend_datepicker
        dateend_datepicker.datePickerMode = .date
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
