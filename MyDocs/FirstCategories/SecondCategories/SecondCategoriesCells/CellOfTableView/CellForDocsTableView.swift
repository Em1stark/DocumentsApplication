//
//  CellForDocsTableView.swift
//  MyDocs
//
//  Created by Алексей Шахов on 18.12.2021.
//

import UIKit
import RealmSwift

protocol MyTableViewCellDelegate: AnyObject{
    func look(image: UIImage?)
    func addButtonTapped(name: String)
}

class CellForDocsTableView: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var addButtonTapped: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editCategoryButton: UIButton!
    
    var tableView: UITableView!
    
    weak var delegate: MyTableViewCellDelegate?
    
    let dbManager: DBManager = DBManagerImpl()
    var arrayOfImages = [CategoryImage]()
    var idCategoryAfterTapButton: ObjectId!
    var value = true
    override func awakeFromNib(){
        super.awakeFromNib()
        
        contentView.backgroundColor = .init(cgColor: .init(red: 0.945, green: 0.973, blue: 1, alpha: 1))
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewID")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .init(cgColor: .init(red: 0.945, green: 0.973, blue: 1, alpha: 1))
        //addButtonTapped.titleLabel?.text = "Photo"
        addButtonTapped.tintColor = UIColor(red: 0.517, green: 0.511, blue: 0.511, alpha: 1)
        addButtonTapped.setImage(UIImage(systemName: "camera.on.rectangle"), for: .normal)
        nameLabel.textColor = UIColor(red: 0.317, green: 0.311, blue: 0.311, alpha: 1)
        editCategoryButton.tintColor = UIColor(red: 0.517, green: 0.511, blue: 0.511, alpha: 1)
        editCategoryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        editCategoryButton.setImage(UIImage(systemName: "circle.dashed"), for: .normal)
    }
    @IBAction func addButtonTapped(_ sender: UIButton) {

        delegate?.addButtonTapped(name: nameLabel.text ?? "")
        collectionView.reloadData()
        }
    
    @IBAction func editCategoryButton(_ sender: UIButton) {
        let button = sender
        if button.isSelected == true {
            button.setImage(UIImage(systemName: "circle.dashed"), for: .normal)
            button.isSelected = false
            value = true
            addButtonTapped.isEnabled = true
            collectionView.reloadData()
            } else {
                button.setImage(UIImage(systemName: "circle.dashed.inset.filled"), for: .normal)
                button.isSelected = true
                value = false
                addButtonTapped.isEnabled = false
                collectionView.reloadData()
            }
        
    
    }
    override func prepareForReuse() {
        self.arrayOfImages = []
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewID", for: indexPath) as? CollectionViewCell else { return CollectionViewCell()}
        
        let data = arrayOfImages[indexPath.item].image
        let dataConvertedToImage: UIImage? = UIImage(data: data)
        cell.deleteImage.isHidden = value
        cell.docImage.image = dataConvertedToImage
        let needImage = arrayOfImages.first(where: {$0.image == data})
        let needId = needImage?.id
        cell.deleteImage.tintColor = .systemGray2
        cell.deleteImage.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        cell.idPickedImage = needId
        cell.tableView = tableView
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
      
        addButtonTapped.addTarget(self, action: #selector(getter: addButtonTapped), for: .touchUpInside)
        let data = arrayOfImages[indexPath.item].image
        let dataConvertedToImage: UIImage? = UIImage(data: data)
        self.delegate?.look(image: dataConvertedToImage)
    }
    
    func set(arrayOfImages: [CategoryImage], nameLabel: String){
        self.nameLabel.text = nameLabel
        self.arrayOfImages = arrayOfImages
        collectionView.reloadData()
        }
}


