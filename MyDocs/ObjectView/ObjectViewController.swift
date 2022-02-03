//
//  ObjectViewController.swift
//  MyDocs
//
//  Created by Алексей Шахов on 17.12.2021.
//

import UIKit
import SwiftUI

protocol DocDelegate: AnyObject {
    func show()
}

class ObjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: DocDelegate?
    
    @IBOutlet weak var addDocButton: UIButton!
    @IBOutlet weak var docTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var secondLabel: UILabel!
    
    var photo: UIImage!
    var imagePicker: ImagePicker!
    var docs = [newModelTableView]() //newModelTableView(name: "Test", images: [])
    
    var idDocs: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        let nib = UINib(nibName: "CellForDocsTableView", bundle: nil)
        docTableView.register(nib, forCellReuseIdentifier: "CellForDocsTableView")
        docTableView.allowsSelection = false
        docTableView.delegate = self
        docTableView.dataSource = self
        
        secondLabel.text = "Documents"
        secondLabel.tintColor = .black
        view.backgroundColor = .init(red: 0.887, green: 0.954, blue: 1, alpha: 1)
        docTableView.backgroundColor = .init(cgColor: .init(red: 0.945, green: 0.973, blue: 1, alpha: 1))
        backButton.tintColor = .black
        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        backButton.setTitle("Back", for: .normal)
        addDocButton.tintColor = .black
        addDocButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        addDocButton.setTitle("Add", for: .normal)
        
    }
    
    @IBAction func addDocButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "SecondSubView", bundle: nil)
        guard let sheetPresentationController = storyboard.instantiateViewController(withIdentifier: "SecondSubView") as? SecondSubView else { return }
        sheetPresentationController.delegate = self
        if let sheet = sheetPresentationController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 32
            sheet.prefersGrabberVisible = true
    
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
        return docs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForDocsTableView", for: indexPath) as! CellForDocsTableView
        let object = docs[indexPath.row]
        cell.set(object: object)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }
    
    // Realization delete objects from tableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            docs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

extension ObjectViewController: newCreationDelegate {
    func created(model: newModelTableView) {
        docs.append(model)
        docTableView.reloadData()
    }
}

extension ObjectViewController: MyTableViewCellDelegate{
    func addButtonTapped(name: String) {
       
//        for i in 0...docs.count - 1 where docs[i].name == name{
//                idDocs = i
//
//        }
        idDocs = docs.firstIndex(where: { $0.name == name })!
        self.imagePicker.present(from: self.view)
    }
    
    func look(image: UIImage) {
        print("Работает")
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
        let oldCategory = docs[idDocs]
        let newImages = oldCategory.images + [image!]
        let newCategory = newModelTableView.init(name: oldCategory.name, images: newImages)
        docs[idDocs] = newCategory
            docTableView.reloadData()
            
        }else{
            docTableView.reloadData()
        }
        
    }
    
}
