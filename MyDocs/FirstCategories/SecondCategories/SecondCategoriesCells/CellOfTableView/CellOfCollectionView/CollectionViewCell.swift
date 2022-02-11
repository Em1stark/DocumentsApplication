//
//  CollectionViewCell.swift
//  MyDocs
//
//  Created by Алексей Шахов on 24.01.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var docImage: UIImageView!
   
    @IBOutlet weak var deleteImage: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        docImage.backgroundColor = .init(cgColor: .init(red: 0.945, green: 0.973, blue: 1, alpha: 1))
        deleteImage.isEnabled = false
        deleteImage.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.docImage.image = nil
    }

    @IBAction func deleteImage(_ sender: Any) {
        
        print("PhotoDeleted!")
        
    }
}


