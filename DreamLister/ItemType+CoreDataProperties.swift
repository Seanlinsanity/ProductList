//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by SEAN on 2017/8/17.
//  Copyright © 2017年 SEAN. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
