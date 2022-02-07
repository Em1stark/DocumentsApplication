//
//  CellForDocsTableView.swift
//  MyDocs
//
//  Created by Алексей Шахов on 18.12.2021.
//

import UIKit

protocol MyTableViewCellDelegate: AnyObject{
    func look(image: UIImage)
    func addButtonTapped(name: String)
}

class CellForDocsTableView: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    weak var delegate: MyTableViewCellDelegate?
    
    @IBOutlet weak var addButtonTapped: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var images: [UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
        self.images = []
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewID", for: indexPath) as! CollectionViewCell
        let image = images[indexPath.item]
        cell.setupCell(image: image)
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                print("Выбрана ячейка: (\(indexPath.section), \(indexPath.item))")
      
        addButtonTapped.addTarget(self, action: #selector(getter: addButtonTapped), for: .touchUpInside)
        self.delegate?.look(image: images[indexPath.item])
    }
    
    func set(object: UserDocument){
        self.nameLabel.text = object.nameOfCategory
        //self.images = object.images
        collectionView.reloadData()
        }
}

