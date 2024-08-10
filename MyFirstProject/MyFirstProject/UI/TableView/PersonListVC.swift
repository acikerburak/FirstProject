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

    // MARK: Initiliaze
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPersons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
            print("Gift Type: \(giftType), Amount: \(giftAmount)")
            if giftType == "Para" {
                cell.detailTextLabel?.text = "\(giftType) - Miktar: \(giftAmount)"
            } else {
                cell.detailTextLabel?.text = "\(giftType)"
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
        persons = DataManager.shared.fetchAllPersons()
        tableView.reloadData()
    }
}

extension DataManager {
    func deletePerson(person: Person) {
        context.delete(person)
        saveContext()
    }
}
