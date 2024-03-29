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
        myDefinition.textColor = UIColor(red: 0.317, green: 0.311, blue: 0.311, alpha: 1)
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Func of configuration cell
    func set(object: User){
        self.myFace.text = object.face
        self.myDefinition.text = object.definition
    }
    
    
}
