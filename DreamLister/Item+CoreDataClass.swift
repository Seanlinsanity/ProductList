//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by SEAN on 2017/8/17.
//  Copyright © 2017年 SEAN. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    public override func awakeFromInsert() { //when you create "Item" from the entity(Anytime that "Item" is inserted into the managed object context), this function will be called
        
        super.awakeFromInsert()
        
        self.created = NSDate()
        //assign the current date to the attribute "created"
    }
    
}
