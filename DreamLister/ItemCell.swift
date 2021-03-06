//
//  ItemCell.swift
//  DreamLister
//
//  Created by SEAN on 2017/8/17.
//  Copyright © 2017年 SEAN. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
  
    func configureCell(item: Item) {
        
        title.text = item.title
        price.text = "\(item.pricce)"
        details.text = item.details
        thumb.image = item.toImage?.image as? UIImage
    }
}
