//
//  NewEntry.swift
//  MyFirstProject
//
//  Created by Burak on 21.07.2024.
//

import UIKit

class NewEntryVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    // MARK: Properties
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfFirstPicker: UITextField!
    @IBOutlet weak var tfSecondPicker: UITextField!
    @IBOutlet weak var tfAmount: UITextField!
    
    let firstPickerView = UIPickerView()
    let secondPickerView = UIPickerView()
    
    let firstPickerData = ["Altın", "Para"]
    var secondPickerData: [String] = []
    
    let goldOptions = ["Gram", "Çeyrek", "Yarım", "Tam"]
    let moneyOptions = ["TL", "Dolar", "Euro"]
    
    // MARK: Initiliaze
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerToolBar()
        
        tfName.delegate = self
        tfFirstPicker.delegate = self
        tfSecondPicker.delegate = self
        tfAmount.delegate = self
        
        firstPickerView.delegate = self
        firstPickerView.dataSource = self
        firstPickerView.tag = 1
        tfFirstPicker.inputView = firstPickerView
        
        secondPickerView.delegate = self
        secondPickerView.dataSource = self
        secondPickerView.tag = 2
        tfSecondPicker.inputView = secondPickerView
        
        tfName.keyboardType = .alphabet
        tfAmount.keyboardType = .numberPad
        
        tfAmount.isEnabled = false
        tfAmount.isHidden = true
    }
    
    // MARK: Functions
    
    @IBAction func SaveButton(_ sender: UIButton) {
        savePerson()
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfFirstPicker {
            return !tfName.text!.isEmpty
        } else if textField == tfSecondPicker {
            return !tfFirstPicker.text!.isEmpty
        } else if textField == tfAmount {
            return !tfSecondPicker.text!.isEmpty && tfFirstPicker.text == "Para"
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfName {
            if tfName.text!.isEmpty {
                return false
            } else {
                tfFirstPicker.becomeFirstResponder()
            }
        } else if textField == tfFirstPicker {
            if tfFirstPicker.text!.isEmpty {
                return false
            } else {
                tfSecondPicker.becomeFirstResponder()
            }
        } else if textField == tfSecondPicker {
            if tfSecondPicker.text!.isEmpty {
                return false
            } else if tfFirstPicker.text == "Para" {
                tfAmount.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        } else if textField == tfAmount {
            if tfAmount.text!.isEmpty {
                return false
            } else {
                textField.resignFirstResponder()
            }
        }
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return firstPickerData.count
        } else {
            return secondPickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return firstPickerData[row]
        } else {
            return secondPickerData[row]
        }
    }
    
    // This function is called when a row is selected in a UIPickerView. Different functionalities are implemented for the picker views using their tag properties. When a selection is made in the first picker view ("firstPickerView"), the data of the second picker view ("secondPickerView") is updated and the amount input field (tfAmount) is enabled or disabled accordingly.
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            tfFirstPicker.text = firstPickerData[row]
            if firstPickerData[row] == "Altın" {
                secondPickerData = goldOptions
                tfAmount.isEnabled = false
                tfAmount.isHidden = true
                tfAmount.text = ""
            } else {
                secondPickerData = moneyOptions
                tfAmount.isEnabled = true
                tfAmount.isHidden = false
            }
            secondPickerView.reloadAllComponents()
            tfFirstPicker.resignFirstResponder()
            tfSecondPicker.becomeFirstResponder()
        } else {
            tfSecondPicker.text = secondPickerData[row]
            tfSecondPicker.resignFirstResponder()
            if tfFirstPicker.text == "Para" {
                tfAmount.becomeFirstResponder()
            }
        }
    }
    
    func pickerToolBar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let OKButton = UIBarButtonItem(title: "Tamam", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissPicker))
        toolBar.setItems([OKButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        tfName.inputAccessoryView = toolBar
        tfFirstPicker.inputAccessoryView = toolBar
        tfSecondPicker.inputAccessoryView = toolBar
        tfAmount.inputAccessoryView = toolBar
    }
    
    // MARK: Actions
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    func savePerson() {
        guard let name = tfName.text, !name.isEmpty,
              let giftType = tfSecondPicker.text, !giftType.isEmpty else {
            return
        }
        
        let giftAmount: Int16? = tfFirstPicker.text == "Para" ? Int16(tfAmount.text ?? "0") : nil
        
        DataManager.shared.addPerson(name: name, giftType: giftType, giftAmount: giftAmount)
        
        // Optionally, show a success message or navigate back
        let alert = UIAlertController(title: "Başarılı", message: "Kişi ve takı başarıyla kaydedildi.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
}
