//
//  ViewController.swift
//  createtableview
//
//  Created by albert Michael on 05/02/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var demotableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var numberArray = [Int]()
    
    var nameArray = [1,2,3,4,5,6,7,8,9,10]
    var n = 50
    var items:[Person]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        demotableView.delegate = self
        demotableView.dataSource = self
        for i in 1...n{
            numberArray.append(i)
        }
        fetchperson()
//        print(numberArray)
       
    }
    
    @IBAction func addPerson(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add person", message: "What is their name?", preferredStyle: .alert)
        
        alert.addTextField()
        let submitButton = UIAlertAction(title: "Add", style: .default) {(action) in
            let textField = alert.textFields![0]
            // create a person object
            let newPerson = Person(context: self.context)
            newPerson.name = textField.text
            newPerson.age = 20
            newPerson.gender = "Male"
            // save the data
            do{
               try self.context.save()
            }
            catch{
                
            }
            //re-fetch the data
            self.fetchperson()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .default) {(action) in}
        alert.addAction(cancelButton)
        alert.addAction(submitButton)
       
        self.present(alert,animated: true,completion: nil)
        
    }
    
    func fetchperson(){
        do{
            self.items = try context.fetch(Person.fetchRequest())
            DispatchQueue.main.async{
                self.demotableView.reloadData()
            }
        }
        catch{
            
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return numberArray.count
        return self.items?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = (demotableView.dequeueReusableCell(withIdentifier: "CreateTableViewCell") as? CreateTableViewCell)!
        
        let person1 = self.items![indexPath.row]
        cell.nameLbl.text = person1.name
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let person  = self.items![indexPath.row]
        let alert = UIAlertController(title: "Edit person", message: "Edit name:", preferredStyle: .alert)
        
        alert.addTextField()
        let textField = alert.textFields![0]
        textField.text = person.name
        
        let saveButton = UIAlertAction(title: "Save", style: .default) {(action) in
            let textField = alert.textFields![0]
            // create a person object
            person.name = textField.text
            
            // save the data
            do{
               try self.context.save()
            }
            catch{
                
            }
            //re-fetch the data
            self.fetchperson()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .default) {(action) in}
        alert.addAction(cancelButton)
        alert.addAction(saveButton)
        
        self.present(alert,animated: true,completion: nil)

        

        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style:.destructive, title: "Delete") { (action, view, completionHandler) in
             
            let personRemove = self.items![indexPath.row]
             
            self.context.delete(personRemove)
            
            do{
               try  self.context.save()
            }
            catch{
                
            }
            
            self.fetchperson()
            
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

