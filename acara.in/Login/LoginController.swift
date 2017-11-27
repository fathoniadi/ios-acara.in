//
//  LoginController.swift
//  acara.in
//
//  Created by Fathoni Adi Kurniawan on 27/11/17.
//  Copyright © 2017 Fathoni Adi Kurniawan. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet var login_navbar: UIView!
    
    @IBOutlet weak var email_textfield: UITextField!
    @IBOutlet weak var password_textfield: UITextField!
    
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
            self.performSegue(withIdentifier: "to_home_sogue", sender: self)
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
