//
//  ViewController.swift
//  MyFirstProject
//
//  Created by Burak on 19.07.2024.
//

import UIKit

class HomePage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func kisiEkleButton(_ sender: UIButton) {
        performSegue(withIdentifier: "newEntryGecis", sender: nil)
    }
    
}

