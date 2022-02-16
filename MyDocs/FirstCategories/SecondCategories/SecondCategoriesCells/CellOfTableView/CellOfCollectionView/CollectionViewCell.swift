//
//  CollectionViewCell.swift
//  MyDocs
//
//  Created by Алексей Шахов on 24.01.2022.
//

import UIKit
import RealmSwift

class CollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var docImage: UIImageView!
    @IBOutlet weak var deleteImage: UIButton!
    var idPickedImage: ObjectId!
    let dbManager: DBManager = DBManagerImpl()
    var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        docImage.backgroundColor = .init(cgColor: .init(red: 0.945, green: 0.973, blue: 1, alpha: 1))
        deleteImage.isEnabled = true
        deleteImage.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.docImage.image = nil
    }

    @IBAction func deleteImage(_ sender: Any) {
        let image = dbManager.getImagesFromData()
        dbManager.deleteImage(image: image, index: idPickedImage)
        tableView.reloadData()
    }
    
//    func set(image: UIImage!, changeValue: Bool){
//        self.docImage.image = docImage.image
//        self.deleteImage.isHidden = changeValue
//        }
}


