//
//  PersonListVC.swift
//  MyFirstProject
//
//  Created by Burak on 31.07.2024.
//

import UIKit
import CoreData

class PersonListVC: UITableViewController {
    
    // MARK: Properties
    var persons: [Person] = []
    
    var exchangeRates: (usd: Double?, eur: Double?, try: Double?, xau: Double?)? = nil

    // MARK: Initiliaze
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPersons()
        
        let sumButton = UIBarButtonItem(title: "Toplam", style: .plain, target: self, action: #selector(sumButtonTapped))
        self.navigationItem.rightBarButtonItem = sumButton
        
        fetchExchangeRates { usdRate, eurRate, tryRate, xauRate in
            DispatchQueue.main.async {
                self.exchangeRates = (usdRate, eurRate, tryRate, xauRate)
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func sumButtonTapped() {
        var totalAmountInTRY: Double = 0.0
        
        guard let exchangeRates = exchangeRates else {
            let alertController = UIAlertController(title: "Hata", message: "Döviz kurları yüklenemedi.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        for person in persons {
            totalAmountInTRY += person.jewelryAmount
            
            if let gift = person.gifts?.anyObject() as? Gift, let giftType = gift.type {
                var convertedAmount: Double = 0.0
                
                switch giftType {
                case "TL":
                    convertedAmount = Double(gift.amount)
                case "Dolar":
                    if let usdRate = exchangeRates.try {
                        convertedAmount = Double(gift.amount) * usdRate
                    }
                case "Euro":
                    if let eurRate = exchangeRates.eur, let tryRate = exchangeRates.try {
                        convertedAmount = Double(gift.amount) * (tryRate / eurRate)
                    }
                case "Gram":
                    if let xauRate = exchangeRates.xau, let tryRate = exchangeRates.try {
                        let oneOunceInUSD = 1 / xauRate
                        let oneOunceInTRY = oneOunceInUSD * tryRate
                        convertedAmount = oneOunceInTRY / 31.1034768
                    }
                case "Çeyrek":
                    if let xauRate = exchangeRates.xau, let tryRate = exchangeRates.try {
                        let oneOunceInUSD = 1 / xauRate
                        let oneOunceInTRY = oneOunceInUSD * tryRate * 1.75
                        convertedAmount = oneOunceInTRY / 31.1034768
                    }
                case "Yarım":
                    if let xauRate = exchangeRates.xau, let tryRate = exchangeRates.try {
                        let oneOunceInUSD = 1 / xauRate
                        let oneOunceInTRY = oneOunceInUSD * tryRate * 3.5
                        convertedAmount = oneOunceInTRY / 31.1034768
                    }
                case "Tam":
                    if let xauRate = exchangeRates.xau, let tryRate = exchangeRates.try {
                        let oneOunceInUSD = 1 / xauRate
                        let oneOunceInTRY = oneOunceInUSD * tryRate * 7.216
                        convertedAmount = oneOunceInTRY / 31.1034768
                    }
                    print("\(convertedAmount)")
                default:
                    break
                }
                
                totalAmountInTRY += convertedAmount
            }
        }
        
        let alertController = UIAlertController(title: "Toplam Tutar", message: "Toplam tutar: \(totalAmountInTRY) TRY", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPersons()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        let person = persons[indexPath.row]
        cell.textLabel?.text = person.name
        
        if let gift = person.gifts?.anyObject() as? Gift {
            let giftType = gift.type ?? ""
            let giftAmount = gift.amount
            if giftType == "Para" {
                cell.detailTextLabel?.text = "\(giftType) - Miktar: \(giftAmount)"
            } else {
                cell.detailTextLabel?.text = "\(giftType) - Miktar: \(giftAmount)"
            }
        } else {
            cell.detailTextLabel?.text = "Takı Bilgisi Yok"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let personToDelete = persons[indexPath.row]
            DataManager.shared.deletePerson(person: personToDelete)
            persons.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let personToEdit = persons[indexPath.row]
        performSegue(withIdentifier: "editPersonSegue", sender: personToEdit)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPersonSegue",
           let destinationVC = segue.destination as? NewEntryVC,
           let personToEdit = sender as? Person {
            destinationVC.personToEdit = personToEdit
        }
    }
    
    func fetchPersons() {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            persons = try context.fetch(fetchRequest)
            print("Yüklenen Kişiler: \(persons)")
        } catch let error {
            print("Veriler yüklenemedi: \(error)")
        }
        
        tableView.reloadData()
    }
}

