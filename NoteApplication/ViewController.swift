//
//  ViewController.swift
//  NoteApplication
//
//  Created by Furkan Kozmaç on 28.07.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var notes: [Note] = []
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(self.didTapAddNoteButton))
        self.setupUI()
        fetchNotes()
    }
    
    @objc func didTapAddNoteButton() {
        let vc = AddNoteViewController()
        vc.title = "Add Note"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchNotes() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        
        do {
            notes = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Data couldn't fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: Configuring tableView
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray6
        tableView.allowsSelection = true
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        return tableView
    }()
    
    
    // MARK: Configuring UI and Constraints
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
        ])
    }
    
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
        tableView.separatorStyle = .none
        let note = notes[indexPath.row]
        cell.titleLabel.text = note.title
        cell.noteLabel.text = note.note
        
        return cell
    }
    
}
