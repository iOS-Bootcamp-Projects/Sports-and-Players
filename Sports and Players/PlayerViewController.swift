//
//  PlayerViewController.swift
//  Sports and Players
//
//  Created by Aamer Essa on 12/12/2022.
//

import UIKit
import CoreData

class PlayerViewController: UIViewController {
    
    
    @IBOutlet weak var playerTableView: UITableView!
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var sportType = String()
    var player = [Player]()
    var sport = Sport()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNewPlayer))

        playerTableView.delegate = self
        playerTableView.dataSource = self
        fetchAllPlayer()
        

       
    }
    

   @objc func addNewPlayer(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Player", message:"", preferredStyle: .alert)
       
        alert.addTextField { playerNameField in
         playerNameField.placeholder = "Name"
        }
        alert.addTextField { playerAge in
            playerAge.placeholder = "Age"
        }
        alert.addTextField { playerHeight in
            playerHeight.placeholder = "Height"
        }
        alert.addTextField { playerWeight in
            playerWeight.placeholder = "Weight"
        }
       
        
       alert.addAction(UIAlertAction(title: "Add", style: .default,handler: { handler in
           
           let playerName = alert.textFields![0] as UITextField
           let playerAge = alert.textFields![1] as UITextField
           let playerHeight = alert.textFields![2] as UITextField
           let playerWeight = alert.textFields![3] as UITextField
           
           
           let newPlayer = Player(context: self.managedObjectContext)
           newPlayer.player_name = playerName.text!
           newPlayer.player_age = playerAge.text!
           newPlayer.player_height = playerHeight.text!
           newPlayer.player_weight = playerWeight.text!
           newPlayer.spotr = self.sport
           
           do{
               try self.managedObjectContext.save()
               self.player.append(newPlayer)
               self.playerTableView.reloadData()
           } catch{
               print("\(error)")
           }
          
           
       }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
        
    } // addNewPlayer()
    
   
    func fetchAllPlayer (){
        let allPlayer = sport.player?.allObjects as? [Player] 
        player = allPlayer!
        
       
    } // end of fetchAllPlayer
    

}

extension PlayerViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        player.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playerTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlayerTableViewCell
        cell.playerName.text = player[indexPath.row].player_name
        cell.playerAge.text = "Age: \(player[indexPath.row].player_age!)"
        cell.playerWeight.text = "Weight: \(player[indexPath.row].player_weight!)"
        cell.playerHeight.text = "Height: \(player[indexPath.row].player_height!)"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            self.managedObjectContext.delete(self.player[indexPath.row])
            do{
                try self.managedObjectContext.save()
                self.player.remove(at: indexPath.row)
                self.playerTableView.reloadData()
            } catch {
                print("\(error)")
            }
          
            completionHandler(true)
        } // delete button
        
       let editAction = UIContextualAction(style: .destructive, title: "Edit") { action, view, completionHandler in
           
           let alert = UIAlertController(title: "Add New Player", message:"", preferredStyle: .alert)
          
          

           alert.addTextField { playerNameField in
            playerNameField.placeholder = "Name"
               playerNameField.text = self.player[indexPath.row].player_name
           }
           alert.addTextField { playerAge in
               playerAge.placeholder = "Age"
               playerAge.text = self.player[indexPath.row].player_age
           }
           alert.addTextField { playerHeight in
               playerHeight.placeholder = "Height"
               playerHeight.text = self.player[indexPath.row].player_height
           }
           alert.addTextField { playerWeight in
               playerWeight.placeholder = "Weight"
               playerWeight.text = self.player[indexPath.row].player_weight
           }
          
           
          alert.addAction(UIAlertAction(title: "Edit", style: .default,handler: { handler in
              let playerName = alert.textFields![0] as UITextField
              let playerAge = alert.textFields![1] as UITextField
              let playerHeight = alert.textFields![2] as UITextField
              let playerWeight = alert.textFields![3] as UITextField
              
              
              let player = self.player[indexPath.row]
              player.player_name = playerName.text!
              player.player_age = playerAge.text!
              player.player_height = playerHeight.text!
              player.player_weight = playerWeight.text!
              player.spotr = self.sport
              
              do{
                  try self.managedObjectContext.save()
                  self.playerTableView.reloadData()
              } catch{
                  print("\(error)")
              }
             
              
          }))
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
           
           self.present(alert, animated: true)

          completionHandler(true)
      }// edit button
        
            editAction.backgroundColor = .blue
            return UISwipeActionsConfiguration(actions: [deleteAction,editAction])
    }

    
    
}
