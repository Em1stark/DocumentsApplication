//
//  CellForDocsTableView.swift
//  MyDocs
//
//  Created by Алексей Шахов on 18.12.2021.
//

import UIKit
import RealmSwift

protocol MyTableViewCellDelegate: AnyObject{
    func look(image: UIImage)
    func addButtonTapped(name: String)
}

class CellForDocsTableView: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    weak var delegate: MyTableViewCellDelegate?
    
    @IBOutlet weak var addButtonTapped: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let mainRealm2 = try! Realm()
    var arrayOfCategories: Results<UserDocument>!
    var arrayOfImages: Results<CategoryImage>!
    var idCategoryAfterTapButton: ObjectId!
    var images: [UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        arrayOfImages = mainRealm2.objects(CategoryImage.self)
        arrayOfCategories = mainRealm2.objects(UserDocument.self).where({$0.nameOfCategory == nameLabel.text!})
        contentView.backgroundColor = .init(cgColor: .init(red: 0.945, green: 0.973, blue: 1, alpha: 1))
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewID")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .init(cgColor: .init(red: 0.945, green: 0.973, blue: 1, alpha: 1))
        addButtonTapped.titleLabel?.text = "Photo"
        addButtonTapped.tintColor = .black
    }
    @IBAction func addButtonTapped(_ sender: UIButton) {

        
        delegate?.addButtonTapped(name: nameLabel.text!)
        
        }
    
    override func prepareForReuse() {
        //self.images = []
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewID", for: indexPath) as! CollectionViewCell
        let data = arrayOfImages[indexPath.item].image
        let dataConvertedToImage : UIImage = UIImage(data: data!)!

        cell.setupCell(image: dataConvertedToImage)
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                print("Выбрана ячейка: (\(indexPath.section), \(indexPath.item))")
      
        addButtonTapped.addTarget(self, action: #selector(getter: addButtonTapped), for: .touchUpInside)
        self.delegate?.look(image: images[indexPath.item])
    }
    
    func set(object: UserDocument, index: ObjectId){
        self.nameLabel.text = object.nameOfCategory
        self.arrayOfImages = object.arrayOfImages.where({$0.idParent == index})
        collectionView.reloadData()
        }
}


