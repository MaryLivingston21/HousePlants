//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Mary Livingston on 2/29/20.
//  Copyright © 2020 Mary Livingston. All rights reserved.
//

import UIKit
class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imageStore: ImageStore!
    var itemStore: ItemStore!
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var lightField: UITextField!
    @IBOutlet var waterField: UITextField!
    @IBOutlet var plantSizeField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var notesField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = item.name
        lightField.text = item.light
        waterField.text = item.water
        plantSizeField.text = item.plantSize
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        notesField.text = item.notes
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        // Get the item key
        let key = item.itemKey
        
        // If there is an associated image with the item
        // display it on the image view
        let imageToDisplay = imageStore.image(forKey: key)
        imageView.image = imageToDisplay
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clear first responder
        view.endEditing(true)
        
        // "Save" changes to item
        item.name = nameField.text ?? ""
        item.light = lightField.text ?? ""
        item.water = waterField.text ?? ""
        item.plantSize = plantSizeField.text ?? ""
        if let valueText = valueField.text,
            let value = numberFormatter.number(from: valueText) {
            item.valueInDollars = value.intValue
        } else {
            item.valueInDollars = 0
        }
        item.notes = notesField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @IBAction func deleteItem(_ sender: UIBarButtonItem) {
        let title = "Delete \(item.name)?"
        let message = "Are you sure you want to delete this item?"
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            
            if (self.item != nil && self.itemStore != nil){
                self.itemStore.removeItem(self.item)
            }
            
            //leave view controller
            self.performSegue(withIdentifier: "returnToTableView", sender: nil)
        })
        ac.addAction(deleteAction)
        
        // Present the alert controller
        present(ac, animated: true, completion: nil)
    }
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        // If the device has a camera, take a picture; otherwise, // just pick from photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        
        // Place image picker on the screen
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        // Get picked image from info dictionary
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Store the image in the ImageStore for the item's key
        imageStore.setImage(image, forKey: item.itemKey)
        
        // Put that image on the screen in the image view
        imageView.image = image
        
        // Take image picker off the screen -
        //you must call this dismiss method
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // If the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "returnToTableView"?:
                let itemViewController = segue.destination as! ItemsViewController
                itemViewController.itemStore = itemStore
                itemViewController.imageStore = imageStore
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    

}
