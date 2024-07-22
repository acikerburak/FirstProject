//
//  NewEntry.swift
//  MyFirstProject
//
//  Created by Burak on 21.07.2024.
//

import UIKit

class NewEntry: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let takiTipi = ["Altın", "Para", "Bilezik"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return takiTipi.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return takiTipi[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = takiTipi[row]
    }
    
    
    let picker = UIPickerView()
    
    @IBOutlet weak var kisiTextField: UITextField!
    @IBOutlet weak var pickerTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerToolBar()
        pickerTextField.inputView = picker
        picker.delegate = self
        picker.dataSource = self
 
    }
    
    func pickerToolBar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        pickerTextField.inputAccessoryView = toolBar
        
        let tamamButton = UIBarButtonItem(title: "Tamam", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissPicker))
        toolBar.setItems([tamamButton], animated: true)
        toolBar.isUserInteractionEnabled = true
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
}
