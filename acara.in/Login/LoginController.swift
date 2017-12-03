//
//  LoginController.swift
//  acara.in
//
//  Created by Fathoni Adi Kurniawan on 27/11/17.
//  Copyright © 2017 Fathoni Adi Kurniawan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginController: UIViewController {

    @IBOutlet var login_navbar: UIView!
    
    @IBOutlet weak var email_textfield: UITextField!
    @IBOutlet weak var password_textfield: UITextField!
    
    let session = UserDefaults.standard
    
    @IBAction func masuk_button(_ sender: UIButton) {
        let email_tf = email_textfield.text!
        let password_tf = password_textfield.text!
        
        var grant_login = true
        var message_err = ""
        
        if(email_tf.isEmpty || password_tf.isEmpty )
        {
            grant_login = false
            if(email_tf.isEmpty)
            {
                message_err = "Email tidak boleh kosong"
            }
            
            if(password_tf.isEmpty)
            {
                message_err = "Password tidak boleh kosong"
            }
        }
        else if(password_tf.isEmpty && email_tf.isEmpty)
        {
            grant_login = false
            message_err = "Email dan Password tidak boleh kosong"
        }
        
        if(grant_login)
        {
            let parameters: [String:Any] = [
                "email" : email_tf,
                "password" : password_tf
            ];
            var flag_true = false
            let urlString = Config.url()+"api/v1/auth/login"
            //guard let url = URL(string: urlString) else { return }
            
            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default)
                .validate()
                .responseJSON { response in
                //print("Request: \(String(describing: response.request))")   // original url request
                //print("Response: \(String(describing: response.response))") // http url response
                //print("Result: \(response.result)")                         // response serialization result
                    
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                    let alert = UIAlertController(title: "Alert", message: "Cannot connect to the server", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    return self.present(alert, animated: true, completion: nil)
                }
                
                    if let json = response.result.value as? [String:Any] {
                    let res = JSON(json)
                    print(res)
                    print(json)
                    
                    let status = json["status"] as! Int
                    print(status)
                    if( Int(status) != 200)
                    {
                        let message = json["message"] as! String
                        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        return self.present(alert, animated: true, completion: nil)
                    }
                    //print("JSON: \(res["status"])") // serialized json response
                   flag_true = true
                   self.session.set(String(describing: res["token"]), forKey: "token")
                   self.performSegue(withIdentifier: "to_home_sogue", sender: self)
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
            }

            //self.performSegue(withIdentifier: "to_home_sogue", sender: self)
        }
        else{
            let alert = UIAlertController(title: "Alert", message: message_err, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
