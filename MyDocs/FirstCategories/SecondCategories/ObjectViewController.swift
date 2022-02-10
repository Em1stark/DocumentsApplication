//
//  ObjectViewController.swift
//  MyDocs
//
//  Created by Алексей Шахов on 17.12.2021.
//

import UIKit
import SwiftUI
import RealmSwift

protocol DocDelegate: AnyObject {
    func show()
}

class ObjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: DocDelegate?
    
    @IBOutlet weak var addDocButton: UIButton!
    @IBOutlet weak var docTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var secondLabel: UILabel!
    
    let mainRealm2 = try! Realm()
    
    var imagePicker: ImagePicker!
    
    let dbManager: DBManager = DBManagerImpl()
    var usersDocumentsArray: Results<UserDocument>!
    var imagesArray: Results<CategoryImage>!
    var idCategory: ObjectId!
    var indexCellOfFirstTableView: ObjectId!
    var secondNameOfLabel: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersDocumentsArray = mainRealm2.objects(UserDocument.self).where({$0.idParent == indexCellOfFirstTableView})
        imagesArray = mainRealm2.objects(CategoryImage.self)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

        let nib = UINib(nibName: "CellForDocsTableView", bundle: nil)
        docTableView.register(nib, forCellReuseIdentifier: "CellForDocsTableView")
        docTableView.allowsSelection = false
        docTableView.delegate = self
        docTableView.dataSource = self
        secondLabel.text = secondNameOfLabel
        secondLabel.tintColor = UIColor(red: 0.217, green: 0.211, blue: 0.211, alpha: 1)
        view.backgroundColor = .init(red: 0.887, green: 0.954, blue: 1, alpha: 1)
        docTableView.backgroundColor = .init(cgColor: .init(red: 0.945, green: 0.973, blue: 1, alpha: 1))
        backButton.tintColor = UIColor(red: 0.117, green: 0.111, blue: 0.111, alpha: 1)
        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        addDocButton.tintColor = UIColor(red: 0.117, green: 0.111, blue: 0.111, alpha: 1)
        addDocButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        addDocButton.setImage(UIImage(systemName: "plus"), for: .normal)
        
    }
    
    @IBAction func addDocButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "SecondSubView", bundle: nil)
        guard let sheetPresentationController = storyboard.instantiateViewController(withIdentifier: "SecondSubView") as? SecondSubView else { return }
        sheetPresentationController.delegate = self
        if let sheet = sheetPresentationController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 32
            sheet.prefersGrabberVisible = true
            sheetPresentationController.indexCellOfFirstTableView = indexCellOfFirstTableView
        }
        self.present(sheetPresentationController, animated: true, completion: nil)
    } 
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersDocumentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellForDocsTableView", for: indexPath) as? CellForDocsTableView else { return  UITableViewCell()}
        let object = usersDocumentsArray[indexPath.row]
        cell.idCategoryAfterTapButton = object.id
        cell.set(arrayOfImages: object.arrayOfImages.reversed().reversed(), nameLabel: object.nameOfCategory)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Realization delete objects from tableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let categoryElement = usersDocumentsArray[indexPath.row]
            dbManager.deleteCategory(userDocumentsArray: usersDocumentsArray, index: categoryElement.id) {
            [weak self] in // Capture list
            self?.docTableView.deleteRows(at: [indexPath], with: .fade)
            self?.docTableView.reloadData()
            }
        }
    }
}

extension ObjectViewController: newCreationDelegate {
    func created(model: String) {

        docTableView.reloadData()
    }
}

extension ObjectViewController: MyTableViewCellDelegate{
    func addButtonTapped(name: String) {
        let firstIndexWithName = usersDocumentsArray.firstIndex(where: {$0.nameOfCategory == name})!
        idCategory = usersDocumentsArray[firstIndexWithName].id
        self.imagePicker.present(from: self.view)
        
    }
    
    func look(image: UIImage) {
        let storyboard = UIStoryboard(name: "FullPictureViewController", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "FullPictureViewController") as? FullPictureViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        
        vc.view.backgroundColor = .init(red: 0.887, green: 0.954, blue: 1, alpha: 1)
        vc.fullImage.backgroundColor = .init(cgColor: .init(red: 0.945, green: 0.973, blue: 1, alpha: 1))
        vc.fullImage.image = image
        
        present(vc, animated: true, completion: nil)
    }
}

extension ObjectViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if image != nil{
            let imageConvertedToData = image!.pngData()
            try! mainRealm2.write{
                for userDocument in mainRealm2.objects(UserDocument.self).where({$0.id == idCategory}){
                    let addedElementToCategoryImage = CategoryImage(image: imageConvertedToData, idParent: userDocument.id, idGrandParent: indexCellOfFirstTableView)
                    userDocument.arrayOfImages.append(addedElementToCategoryImage)
                    mainRealm2.add(userDocument)
                    docTableView.reloadData()
                }
            }
        }else{
            docTableView.reloadData()
        }
    }
}