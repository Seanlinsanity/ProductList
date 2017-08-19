//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by SEAN on 2017/8/18.
//  Copyright © 2017年 SEAN. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var ThumbImg: UIImageView!
    
    var stores = [Store]()  //create an array of the entity of Store
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.


        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
//        let store = Store(context: context)
//        store.name = "Very Buy"
//        let store2 = Store(context: context)
//        store2.name = "NBA Store"
//        let store3 = Store(context: context)
//        store3.name = "Nike Outlet"
//        let store4 = Store(context: context)
//        store4.name = "Addidas Outlet"
//        let store5 = Store(context: context)
//        store5.name = "Under Armour"
//        let store6 = Store(context: context)
//        store6.name = "PUMA Store"
//        
//        ad.saveContext()
        getStores()
        
        if itemToEdit != nil {
            
            loadItemData()
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //update when selected
    }
    
    func getStores() {
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do{
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
            
        }catch{
            //handle the error
        }
    }
    @IBAction func savePressed(_ sender: UIButton) {
        
        //let item = Item(context: context) //insert a new item
        
        var item: Item!
        
        let picture = Image(context: context) //create a entity of Image entity
        picture.image = ThumbImg.image
        
        
        if itemToEdit == nil {
            item = Item(context: context)
        }else{
            item = itemToEdit //update the exsiting item
        }
        
        item.toImage = picture // assign one entity to another entity
        
        if let title = titleField.text{
            item.title = title
        }
        if let price = priceField.text{
            item.pricce = (price as NSString).doubleValue  //change the type of string into double
        }
        
        if let details = detailsField.text{
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
        navigationController?.popViewController(animated: true) //go back to the MainVC
        
    }
    
    func loadItemData() {
    
        if let item = itemToEdit {
        
            titleField.text = item.title
            priceField.text = "\(item.pricce)"
            detailsField.text = item.details
            ThumbImg.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore{
                
                var index = 0
                repeat{
                    
                    let s = stores[index]
                    if s.name == store.name {
                        
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                    
                }while (index < stores.count)
            }
        }
        
        
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            ThumbImg.image = img
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
