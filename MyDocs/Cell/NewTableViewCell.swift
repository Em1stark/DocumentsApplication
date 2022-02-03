//
//  TableViewCell.swift
//  MyProduct
//
//  Created by Алексей Шахов on 13.12.2021.
//

import UIKit

class NewTableViewCell: UITableViewCell {

    @IBOutlet var myDefinition: UILabel!
    @IBOutlet var myFace: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Func of configuration cell
    func set(object: RealmDataBase){
        self.myFace.text = object.face
        self.myDefinition.text = object.definition
    }
    
    
}
