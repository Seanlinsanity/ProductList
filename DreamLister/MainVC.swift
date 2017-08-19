//
//  ViewController.swift
//  DreamLister
//
//  Created by SEAN on 2017/8/17.
//  Copyright © 2017年 SEAN. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller: NSFetchedResultsController<Item>!
    //declare a FetchedResultsController, and fetching the "Item" entity.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //generateTestData()
        attemptFetch()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell" , for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
        
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        
        //update cell
        
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objs = controller.fetchedObjects , objs.count > 0 {
            
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections{
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections{
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150 //keep the heigth for the cell row
    }
    
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        //create a fetch request and tell it what to go fetch
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        //Tell the fetch result controller how to sort the data (sort by date)
        let priceSort = NSSortDescriptor(key: "pricce", ascending: false)
        let titleSort = NSSortDescriptor(key: "title", ascending: false)
        
        if segment.selectedSegmentIndex == 0 {
            fetchRequest.sortDescriptors = [dateSort]
        } else if segment.selectedSegmentIndex == 1{
            fetchRequest.sortDescriptors = [priceSort]
        } else if segment.selectedSegmentIndex == 2{
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        //initialize a fetch results controller
        //context is a simplified func which is setted in the end of AppDelegate (Go the see the AppDelegate)
        
        controller.delegate = self
        self.controller = controller //set the inside controller to the outside one
        
        do {
            try controller.performFetch()
            
        }catch{
            
            let error = error as NSError
            print("\(error)")
        }
    }
    
    
    @IBAction func segmentChange(_ sender: Any) {
        
        attemptFetch()
        tableView.reloadData()
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //whenever the tableview is about to update, it will start to listen for changes and handle that.
        
        tableView.beginUpdates()
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //Once the content has been changed
        
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        //this is gonna be listening for when we're gonna make changes
        
        switch(type) {
            
        case.insert: //create a new Item
            if let indexPath = newIndexPath {
                
                tableView.insertRows(at: [indexPath], with: .fade) //.fade is a style how the animation when it inserts
            }
            break
        case.delete: //deleting an existing one
            if let indexPath = indexPath {
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update: //select an existing cell and update it
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)//update the cell data
            
            }
            break
        case.move: //drag and move one cell to else where 
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
        
    }
    
    func generateTestData() { //put items into the NSManagedObjectContext and save
        
        let item = Item(context: context)
        item.title = "Macbook Air"
        item.pricce = 2400
        item.details = "I can't work without the awesome Macbook Air"
        
        let item2 = Item(context: context)
        item2.title = "Macbook Pro"
        item2.pricce = 3000
        item2.details = "I can't work without the awesome Macbook Air"
    
        let item3 = Item(context: context)
        item3.title = "Asus XI"
        item3.pricce = 1700
        item3.details = "I can't work without the awesome Macbook Air"
        
        //Stopping here is not saved
        
        ad.saveContext()  //Items is exactly saved. (ad is setted in the end of AppDelegate)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

