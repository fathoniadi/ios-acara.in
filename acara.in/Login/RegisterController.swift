//
//  RegisterController.swift
//  acara.in
//
//  Created by Fathoni Adi Kurniawan on 10/12/17.
//  Copyright © 2017 Fathoni Adi Kurniawan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterController: UIViewController {
    @IBOutlet var name_textfield: UITextField!
    @IBOutlet var email_textfield: UITextField!
    @IBOutlet var password_textfield: UITextField!
    @IBOutlet var cpassword_textfield: UITextField!
    
    @IBAction func register_button(_ sender: UIButton)
    {
        if(cpassword_textfield.text != password_textfield.text)
        {
            let alert = UIAlertController(title: "Gagal Register", message: "Password dan Konfirmasi Password tidak sama", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let parameters: [String:Any] = [
            "email" : email_textfield.text!,
            "password" : password_textfield.text!,
            "cpassword": cpassword_textfield.text!,
            "name": name_textfield.text!
        ];
        
        let urlString = Config.url()+"api/v1/auth/register"
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseJSON { response in
                //print("Request: \(String(describing: response.request))")   // original url request
                //print("Response: \(String(describing: response.response))") // http url response
                //print("Result: \(response.result)")                         // response serialization result
                
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                    let alert = UIAlertController(title: "Gagal Login", message: "Cannot connect to the server", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    return self.present(alert, animated: true, completion: nil)
                }
                
                if let json = response.result.value as? [String:Any] {
                    let status = json["status"] as! Int
                    //print(status)
                    if( Int(status) != 200)
                    {
                        let message = json["message"] as! String
                        let alert = UIAlertController(title: "Gagal Login", message: message, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        return self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Berhasil", message: "Berhasil Registrasi, Silahkan login terlebih dahulu", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:  { (action: UIAlertAction!) in
                            self.performSegue(withIdentifier: "to_init_segue", sender: nil)
                        }))
                        return self.present(alert, animated: true, completion: nil)
                    }
                   //Betul
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
