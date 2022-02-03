//
//  firstSubView.swift
//  MyDocs
//
//  Created by Алексей Шахов on 16.12.2021.
//

import UIKit
import SwiftUI
import RealmSwift

protocol CreationDelegate: AnyObject {
    func created(model: RealmDataBase)
}

class firstSubView: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var iconTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    weak var delegate: CreationDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        nameTextField.textColor = UIColor(red: 0.488, green: 0.488, blue: 0.488, alpha: 1)
        nameTextField.placeholder = "Icon"
        
        iconTextField.delegate = self
        iconTextField.textColor = UIColor(red: 0.488, green: 0.488, blue: 0.488, alpha: 1)
        iconTextField.placeholder = "Name"

        cancelButton.tintColor = .red
        
        view.backgroundColor = .white
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        nameTextField.backgroundColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 0.5)
        nameTextField.borderStyle = .none
        nameTextField.leftViewMode = .always
        nameTextField.leftView = spacerView

        let spacerView2 = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        iconTextField.backgroundColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 0.5)
        iconTextField.borderStyle = .none
        iconTextField.leftViewMode = .always
        iconTextField.leftView = spacerView2
        
        saveButton.tintColor = .black
        saveButton.layer.cornerRadius = 14
        saveButton.backgroundColor = .init(red: 0.837, green: 0.932, blue: 1, alpha: 0.9)
        
        nameLabel.textColor = UIColor(red: 0.317, green: 0.311, blue: 0.311, alpha: 1)
        nameLabel.text = "Category"
        nameLabel.font = .boldSystemFont(ofSize: 24)
        updateSaveButtonState()
        
    }
    
    var newObject = modelTableView(face: "", definition: "")
    
    // Realization cancelButton
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Realization saveButton
    @IBAction func saveButton(_ sender: UIButton) {
        let nameText = nameTextField.text ?? ""
        let iconText = iconTextField.text ?? ""
        let value = RealmDataBase(value: ["\(String(describing: nameText))", "\(String(describing: iconText))"])
        delegate?.created(model: value)
        dismiss(animated: true)
    }
    
    // Logic check textFields is Empty
    func updateSaveButtonState(){
        let nameText = nameTextField.text ?? ""
        let iconText = iconTextField.text ?? ""
        saveButton.isEnabled = !nameText.isEmpty && !iconText.isEmpty
    }
    
    // Func for check textFields is Empty
    @IBAction func textChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
}

