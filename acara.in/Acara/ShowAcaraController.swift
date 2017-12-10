//
//  ShowAcaraController.swift
//  acara.in
//
//  Created by Fathoni Adi Kurniawan on 10/12/17.
//  Copyright © 2017 Fathoni Adi Kurniawan. All rights reserved.
//

import UIKit
import Alamofire

class ShowAcaraController: UIViewController {

    let session = UserDefaults.standard
    
    @IBOutlet var name_label: UILabel!
    @IBOutlet var kategori_label: UILabel!
    @IBOutlet var tanggal_label: UILabel!
    @IBOutlet var owner_label: UILabel!
    @IBOutlet var deskripsi_textview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                            var name = ""
                            var description = ""
                            var date = ""
                            var category_name = ""
                            var owner_name = ""
                            
                            if let value = data["name"] as? String
                            {
                                name = value
                            }
                            
                            if let value = data["tanggal"] as? String
                            {
                                var formater = DateFormatter()
                                formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                                let date_format = formater.date(from: value)!

                                formater = DateFormatter()
                                formater.dateStyle = .medium
                                formater.timeStyle = .none
                                date = formater.string(from: date_format)
                            }
                            
                            if let value = data["description"] as? String
                            {
                                description = value
                            }
                            
                            if let category = data["category"] as? [String:Any]
                            {
                                category_name = category["name"] as! String
                            }
                            
                            if let user = data["user"] as? [String:Any]
                            {
                                owner_name = user["name"] as! String
                            }
                            
                            self.name_label.text = name
                            self.kategori_label.text = category_name
                            self.owner_label.text = owner_name
                            self.tanggal_label.text = date
                            self.deskripsi_textview.text = description
                            
                        }
                    }
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    //print("Data: \(utf8Text)") // original server data as UTF8 string
                }
        }
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
