//
//  ViewController.swift
//  acara.in
//
//  Created by Fathoni Adi Kurniawan on 26/11/17.
//  Copyright © 2017 Fathoni Adi Kurniawan. All rights reserved.
//

import UIKit
import JWT

class ViewController: UIViewController {

  
    @IBAction func login_button(_ sender: UIButton) {
        self.performSegue(withIdentifier: "login_sogue", sender: self)
    }
    
    @IBAction func signup_button(_ sender: UIButton) {
        self.performSegue(withIdentifier: "daftar_sogue", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returned(segue: UIStoryboardSegue) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }


}

