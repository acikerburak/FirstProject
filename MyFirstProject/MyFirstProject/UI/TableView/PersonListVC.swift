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

    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
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
            print("Gift Type: \(giftType), Amount: \(gift.amount)") // Debug Control
            if giftType == "Para" {
                cell.detailTextLabel?.text = "\(giftType) - Miktar: \(gift.amount)"
            } else {
                cell.detailTextLabel?.text = giftType
            }
        } else {
            cell.detailTextLabel?.text = "Takı Bilgisi Yok"
        }

        return cell
    }
    
    func fetchPersons() {
        persons = DataManager.shared.fetchAllPersons()
        tableView.reloadData()
    }
}
