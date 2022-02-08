//
//  CollectionViewCell.swift
//  MyDocs
//
//  Created by Алексей Шахов on 24.01.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var docImage: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        docImage.backgroundColor = .init(cgColor: .init(red: 0.945, green: 0.973, blue: 1, alpha: 1))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.docImage.image = nil
    }

    func setupCell(image: UIImage){
        
        self.docImage.image = image
    }
}


