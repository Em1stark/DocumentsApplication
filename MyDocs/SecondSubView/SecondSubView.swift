//
//  SecondSubView.swift
//  MyDocs
//
//  Created by Алексей Шахов on 25.01.2022.
//

import UIKit
import SwiftUI

protocol newCreationDelegate: AnyObject {
    func created(model: newModelTableView)
}

class SecondSubView: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    weak var delegate: newCreationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.tintColor = .black
        saveButton.layer.cornerRadius = 14
        saveButton.backgroundColor = .init(red: 0.837, green: 0.932, blue: 1, alpha: 0.9)
        
        view.backgroundColor = .white
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        textField.delegate = self
        textField.backgroundColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 0.5)
        textField.borderStyle = .none
        textField.leftViewMode = .always
        textField.leftView = spacerView
        
        textLabel.textColor = UIColor(red: 0.317, green: 0.311, blue: 0.311, alpha: 1)
        textLabel.text = "Category"
        textLabel.font = .boldSystemFont(ofSize: 24)
        updateSaveButtonState()
    }
    var newObject = newModelTableView(name: "", images: [])
    
    @IBAction func saveButton(_ sender: Any) {
        let nameText = textField.text ?? ""
        let newObject = newModelTableView(name: nameText, images: [])
        delegate?.created(model: newObject)
        dismiss(animated: true)
    }
    
    // Logic check textFields is Empty
    func updateSaveButtonState(){
        let nameText = textField.text ?? ""
        saveButton.isEnabled = !nameText.isEmpty
    }
    
    // Func for check textFields is Empty
    @IBAction func textChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
