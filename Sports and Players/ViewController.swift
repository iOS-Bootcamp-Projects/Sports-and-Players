//
//  ViewController.swift
//  Sports and Players
//
//  Created by Aamer Essa on 12/12/2022.
//

import UIKit
import CoreData

protocol images {
    func showImage(pointer:Int)
}

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, images {
    var sports = [Sport] ()
    var pointer = Int()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var sportsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sportsTableView.dataSource = self
        sportsTableView.delegate = self
        fetchAllSports()
           
    }
    

    @IBAction func addNewSport(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Sport", message: "Please enter the name of the sport", preferredStyle: .alert)
        
        alert.addTextField { sportNameField in
            sportNameField.placeholder = "Soccer, Football, Tennis, etc" }
       
        
        alert.addAction(UIAlertAction(title: "Save", style: .default,handler: { handelr in
            
            let sportTextField = alert.textFields![0] as UITextField
            
            if let sportName = sportTextField.text {
                if sportName != "" {
                    let newSport = Sport(context: self.managedObjectContext)
                    newSport.name = sportName
                    newSport.image = Data(count: 1)
                    do {
                        try self.managedObjectContext.save()
                        self.sports.append(newSport)
                        self.sportsTableView.reloadData()
                    } catch{
                        print("\(error)")
                    }
                }
            }
            
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    
    func fetchAllSports (){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sport")
        do{
            let resualt = try managedObjectContext.fetch(request)
              sports = resualt as! [Sport]
        } catch {
            print("\(error)")
        }
       

    } // end of fetchAllTa
    
    func showImage(pointer:Int) {
       
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = true
            present(vc, animated: true)
        self.pointer = pointer
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
         
            let sport = sports[pointer]
            sport.image = image.pngData()
            pointer = 0
            
           
            do {
                try managedObjectContext.save()
                 fetchAllSports()
                sportsTableView.reloadData()
            }
            catch {
                print(error)
            }
           
        }
        picker.dismiss(animated: true)
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = sportsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SportsTableViewCell
        let sport = sports[indexPath.row]
        cell.sportsName.text = sport.name
        cell.imagePicker = self
        cell.pointer = indexPath.row
        cell.addImageBtn.tag = indexPath.row
        
        if sports[indexPath.row].image! == Data(count: 1) {
            cell.sportImage.isHidden = true
            cell.addImageBtn.isHidden = false
            
        } else{
            cell.sportImage.image = UIImage(data: sports[indexPath.row].image!)
            cell.addImageBtn.isHidden = true
            cell.sportImage.isHidden = false
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            self.managedObjectContext.delete(self.sports[indexPath.row])
            do{
                try self.managedObjectContext.save()
                self.sports.remove(at: indexPath.row)
                self.sportsTableView.reloadData()
            } catch {
                print("\(error)")
            }
          
            completionHandler(true)
        } // delete button
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { action, view, completionHandler in
            
            let alert = UIAlertController(title: "Edit Sports", message: "", preferredStyle: .alert)
            
            alert.addTextField { sportNameField in
                sportNameField.text = self.sports[indexPath.row].name
            }
            
            alert.addAction(UIAlertAction(title: "Edit", style: .default,handler: { handler in
                
                let sportTextField = alert.textFields![0] as UITextField
                
                if let sportName = sportTextField.text {
                    if sportName != "" {
                        let editSport = self.sports[indexPath.row]
                        editSport.name = sportName
                        do {
                            try self.managedObjectContext.save()
                            self.sportsTableView.reloadData()
                            
                            } catch{
                                print("\(error)")
                            }
                        }
                }

                }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
            completionHandler(true)
        }// edit button
        
            editAction.backgroundColor = .blue
            return UISwipeActionsConfiguration(actions: [deleteAction,editAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let playerView = storyboard?.instantiateViewController(withIdentifier: "PlayerView") as! PlayerViewController
        playerView.title = sports[indexPath.row].name!
        playerView.sport = sports[indexPath.row]
        self.navigationController?.pushViewController(playerView, animated: true)
    }
 
    
    
}
