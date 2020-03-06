//
//  NotesTableViewController.swift
//  YNotes
//
//  Created by Dzhek on 18/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    // MARK: - Properties
    private var notes: [Note] {
        get { return Array(notebook.notes.values).sorted(by: { $0.lastEditedDate > $1.lastEditedDate }) }
        set {}
    }
    
    let notebook = FileNotebook()
    let mainQueue = OperationQueue.main
    let commonQueue = OperationQueue()
    let dbQueue = OperationQueue()
    let backendQueue = OperationQueue()
    

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.commonQueue.qualityOfService = .userInteractive
    }
    
    private func loadData() {
        
        let loadNotesOperation = LoadNotesOperation(notebook: notebook,
                                                    modelName: "YNotes",
                                                    dbQueue: dbQueue,
                                                    backendQueue: backendQueue)
        loadNotesOperation.completionBlock = {
            if loadNotesOperation.result! {
                self.mainQueue.addOperation {
                    self.tableView.reloadData()
                }
            }
        }
        
        self.commonQueue.addOperation(loadNotesOperation)
    }
    
    private func setUpViews() {
        self.title = "Notes"
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(hex: "01B3E4")
        self.tableView.allowsMultipleSelectionDuringEditing = false
        self.tableView.tableFooterView = UIView()
        
        self.clearsSelectionOnViewWillAppear = false
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        self.tableView.setEditing(tableView.isEditing, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
        cell.setStyle()
        let note = self.notes[indexPath.row]
        cell.titleLabel.text = note.title
        cell.contentLabel.text = note.content
        cell.date.text = note.selfDestructionDate?.asString()
        cell.colorOfNoteView.backgroundColor = note.color
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
  
        let uid = self.notes[indexPath.row].uid
        let removeNoteOperation = RemoveNoteOperation(uid: uid,
                                                      notebook: self.notebook,
                                                      modelName: "YNotes",
                                                      dbQueue: self.dbQueue,
                                                      backendQueue: self.backendQueue)
        
        removeNoteOperation.completionBlock = {
            self.mainQueue.addOperation {
                let indexPaths = [indexPath]
                self.tableView.deleteRows(at: indexPaths, with: .automatic)
            }
        }
        
        self.commonQueue.addOperation(removeNoteOperation)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewNote" {
            if let editingNoteViewController = segue.destination as? EditingNoteViewController {
                editingNoteViewController.delegate = self
            }
        }
        else if segue.identifier == "editNote" {
            if let editingNoteViewController = segue.destination as? EditingNoteViewController {
                if let cell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: cell) {
                    let note = self.notes[indexPath.row]
                    editingNoteViewController.note = note
                    editingNoteViewController.delegate = self
                }
            }
        }
    }
    
    
}

extension NotesTableViewController: EditingNoteViewControllerDelegate {
    
    func editingDidCancel(_ controller: EditingNoteViewController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func editingDidSave(_ controller: EditingNoteViewController, didSave note: Note, isEdited: Bool) {
        
        let saveNoteOperation = SaveNoteOperation(note: note,
                                                  notebook: self.notebook,
                                                  modelName: "YNotes",
                                                  dbQueue: self.dbQueue,
                                                  backendQueue: self.backendQueue)
        
        saveNoteOperation.completionBlock = {
            self.mainQueue.addOperation {
                let indexPath = IndexPath(row: 0, section: 0)
                if isEdited {
                    guard let oldIndexPath = self.tableView.indexPathForSelectedRow
                        else {
                            logError("Error calculate 'old_Index_Path'")
                            return }
                    self.tableView.moveRow(at: oldIndexPath, to: indexPath)
                } else {
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                }
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                self.navigationController?.popViewController(animated: true)
            }
            self.loadData()
        }
        
        self.commonQueue.addOperation(saveNoteOperation)
    
    }
    
    
}

