//
//  AddNoteViewController.swift
//  NoteApplication
//
//  Created by Furkan Kozmaç on 28.07.2023.
//

import UIKit
import CoreData

class AddNoteViewController: UIViewController {
    
    // MARK: STYLING ELEMENTS
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.placeholder = "Add title"
        return textField
        
    }()
    
    let noteTextField: UITextView = {
        let textField = UITextView()
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        textField.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 10)
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.isScrollEnabled = true
        return textField
        
    }()
    
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .link
        button.configuration?.title = "Save"
        
        return button
    }()
    
    // MARK: FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        
        setupUI()
        
    }
    
    @objc func didTapSaveButton() {
        
        if (titleTextField.text !=  "" && noteTextField.text != "") {
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let newNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context)
            
            newNote.setValue(titleTextField.text, forKey: "title")
            newNote.setValue(noteTextField.text, forKey: "note")
            
            do {
                try context.save()
                print("Data stored successfully.")
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("Error: Couldn't store data. \(error.localizedDescription)")
            }
        } else {
            let alert = UIAlertController(title: "Warning", message: "Notes can't be empty.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            
            self.present(alert, animated: true)
        }
    }
    
    // MARK: SETTING UP UI - CONSTRAINTS
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleTextField)
        view.addSubview(noteTextField)
        view.addSubview(saveButton)
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        noteTextField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            noteTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            noteTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noteTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            noteTextField.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
}
