//
//  NewEntry.swift
//  MyFirstProject
//
//  Created by Burak on 21.07.2024.
//

import UIKit

class NewEntryVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Properties
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfFirstPicker: UITextField!
    
    let picker = UIPickerView()
    let jewelryType = ["Altın", "Para"]
    
    // MARK: Initiliaze
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerToolBar()
        tfFirstPicker.inputView = picker
        picker.delegate = self
        picker.dataSource = self
    }
    
    // MARK: Functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return jewelryType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return jewelryType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tfFirstPicker.text = jewelryType[row]
    }
    
    func pickerToolBar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        tfFirstPicker.inputAccessoryView = toolBar
        
        let OKButton = UIBarButtonItem(title: "Tamam", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissPicker))
        toolBar.setItems([OKButton], animated: true)
        toolBar.isUserInteractionEnabled = true
    }
    
    // MARK: Actions
    @objc func dismissPicker() {
        view.endEditing(true)
    }
}
