//
//  ViewController.swift
//  MyFirstProject
//
//  Created by Burak on 19.07.2024.
//

import UIKit

class HomePageVC: UIViewController {
    
    // MARK: Initiliaze
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Functions
    @IBAction func addPersonButton(_ sender: Any) {
        performSegue(withIdentifier: "toNewEntryVC", sender: nil)
    }
}

