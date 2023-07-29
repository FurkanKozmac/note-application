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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(self.didTapDeleteAllButton))
        
        self.setupUI()
        fetchNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchNotes()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Button Actions
    
    @objc func didTapAddNoteButton() {
        let vc = AddNoteViewController()
        vc.title = "Add Note"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapDeleteAllButton() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        do {
            let items = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            for item in items {
                managedContext.delete(item)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Error deleting data: \(error), \(error.userInfo)")
        }
        self.tableView.reloadData()
    }
    
    // MARK: Fetch Data
    
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
    
    // MARK: Delete Selected Data
    
    func deleteNote(at indexPath: IndexPath) {
        let noteToDelete = notes[indexPath.row]
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(noteToDelete)
        
        do {
            try managedContext.save()
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } catch let error as NSError {
            print("Error deleting note: \(error), \(error.userInfo)")
        }
    }
    
    // MARK: Configuring tableView
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        return tableView
    }()
    
    
    // MARK: Configuring UI and Constraints
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
        let note = notes[indexPath.row]
        cell.titleLabel.text = note.title
        cell.noteLabel.text = note.note
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.deleteNote(at: indexPath)
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
