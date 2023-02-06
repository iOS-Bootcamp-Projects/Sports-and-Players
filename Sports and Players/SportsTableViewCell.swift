//
//  SportsTableViewCell.swift
//  Sports and Players
//
//  Created by Aamer Essa on 12/12/2022.
//

import UIKit

class SportsTableViewCell: UITableViewCell,UIImagePickerControllerDelegate & UINavigationControllerDelegate  {

    @IBOutlet weak var addImageBtn: UIButton!
    @IBOutlet weak var sportsName: UILabel!
        var imagePicker:images?
    var pointer = Int()
    @IBOutlet weak var sportImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    
    }
    
  
    
  
    
    @IBAction func addImage(_ sender: UIButton) {
        imagePicker?.showImage(pointer: sender.tag)
      
        
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
//
//            print(image)
//        }
//        picker.dismiss(animated: true)
//    }
   
    
      
    

}
