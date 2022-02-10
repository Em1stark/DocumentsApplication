//
//  ViewController.swift
//  MyProduct
//
//  Created by Алексей Шахов on 13.12.2021.
//

import UIKit
import SwiftUI
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    var count = 0
    let dbManager: DBManager = DBManagerImpl()
    let mainRealm2 = try! Realm()
    var realmDataBaseArray: Results<User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realmDataBaseArray = mainRealm2.objects(User.self)
        
        // Connect nib for element (cell) of tableView
        firstLabel.tintColor = UIColor(red: 0.217, green: 0.211, blue: 0.211, alpha: 1)
        firstLabel.text = "Documents"
        view.backgroundColor = .init(red: 0.887, green: 0.954, blue: 1, alpha: 1)
        let nib = UINib(nibName: "NewTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NewTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .init(cgColor: .init(red: 0.945, green: 0.973, blue: 1, alpha: 1))
        editButton.tintColor = UIColor(red: 0.117, green: 0.111, blue: 0.111, alpha: 1)
        editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        editButton.setImage(UIImage(systemName: "list.bullet.rectangle.portrait"), for: .normal)
        addButton.tintColor = UIColor(red: 0.117, green: 0.111, blue: 0.111, alpha: 1)
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        //addButton.setTitle("Add", for: .normal)
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        
    }
    
    // Create edit Button

    @IBAction func editButton(_ sender: UIButton) {
        if tableView.isEditing{
            tableView.setEditing(false, animated: true)
            editButton.setImage(UIImage(systemName: "list.bullet.rectangle.portrait"), for: .normal)
            addButton.isEnabled = true
        }else{
            tableView.setEditing(true, animated: true)
            editButton.setImage(UIImage(systemName: "list.bullet.rectangle.portrait.fill"), for: .normal)
            addButton.isEnabled = false
            
        }
    }
    
    // create addButton
    @IBAction func addButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "firstSubView", bundle: nil)
        
        guard let sheetPresentationController = storyboard.instantiateViewController(withIdentifier: "firstSubView") as? firstSubView else { return
        }
        sheetPresentationController.delegate = self
        
        if let sheet = sheetPresentationController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 32
            sheet.prefersGrabberVisible = true
        }
        self.present(sheetPresentationController, animated: true, completion: nil)
        
    }
    
    // TableView Funcs
    // Number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmDataBaseArray.count
    }
    
    // Change cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewTableViewCell", for: indexPath) as! NewTableViewCell
        let object = realmDataBaseArray[indexPath.row]
        //object._id
        cell.set(object: object)
        cell.backgroundColor = .init(red: 0.983, green: 0.983, blue: 0.983, alpha: 1)
        
        
        return cell
    }
    
    // Realization delete button objects from personOfFamily
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Realization delete objects from tableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            dbManager.deleteUser(realmDataBaseArray: realmDataBaseArray, tableView: tableView, indexPath: indexPath)
            let userElement = realmDataBaseArray[indexPath.row]
            dbManager.deleteUser(realmDataBaseArray: realmDataBaseArray, index: userElement.id) {
                [weak self] in // Capture list
                self?.tableView.deleteRows(at: [indexPath], with: .fade)
                self?.tableView.reloadData()
            }
        }
    }
    
    // Create button for move objects in tableView
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Realization logic for move objects in tableView
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let movedObject = personOfFamily[sourceIndexPath.row]
//        personOfFamily.remove(at: sourceIndexPath.row)
//        personOfFamily.insert(movedObject, at: destinationIndexPath.row)
//        tableView.reloadData()
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 64 //or whatever you need
    }
    
    // Logic for tap on cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "ObjectViewController", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ObjectViewController") as? ObjectViewController else { return }
        let object = realmDataBaseArray[indexPath.row]
        vc.indexCellOfFirstTableView = object.id
        //vc.modalTransitionStyle = .flipHorizontal // это значение можно менять для разных видов анимации появления
        vc.modalPresentationStyle = .fullScreen  // это та самая волшебная строка, убрав или закомментировав ее, вы получите появление смахиваемого контроллера
        vc.secondNameOfLabel = object.definition
        
        self.present(vc, animated: true, completion: nil)
    }
}

extension ViewController: CreationDelegate {
    func created(model: String) {
        tableView.reloadData()
    }
}

