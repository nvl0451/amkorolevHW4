//
//  ViewController.swift
//  amkorolevHW4
//
//  Created by Андрей Королев on 19.03.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "CoreDataNotes")
        container.loadPersistentStores {_, error in
            if let error = error {
                fatalError("Container loading fatal error!")
            }
        }
        return container.viewContext
    }()
    
    func saveChanges() {
        if context.hasChanges {
            try? context.save()
        }
        if let notes = try? context.fetch(Note.fetchRequest()) {
            self.notes = notes
        } else {
            self.notes = []
        }
    }
    
    func loadData() {
        if let notes = try? context.fetch(Note.fetchRequest()) {
            self.notes = notes.sorted(by: {
                $0.creationData.compare($1.creationData) == .orderedDescending
            })
        } else {
            self.notes = []
        }
    }
    
    @IBOutlet weak var emptyCollectionLabel: UILabel!
    
    @IBOutlet weak var notesCollectionView: UICollectionView!
    
    var notes: [Note] = [] {
        didSet {
            emptyCollectionLabel.isHidden = (notes.count != 0)
            notesCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notesCollectionView.delegate = self
        notesCollectionView.dataSource = self
        
        self.loadData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNote(sender:)))
    }
    
    @objc func createNote(sender: UIBarButtonItem) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "NoteViewController") as? NoteViewController else {
            return
        }
        vc.outputVC = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCell", for: indexPath) as! NoteCell
        let note = notes[indexPath.row]
        cell.title.text = note.title
        cell.desc.text = note.descriptionText
        //cell.titleLabel.text = "Breathe in"
        //cell.descriptionLabel.text = "Breathe out"
        return cell
    }
    

}

class NoteCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var desc: UILabel!
}

class NoteViewController: UIViewController {
    var outputVC: ViewController = ViewController()
    
    @IBOutlet weak var noteTitle: UITextField!
    
    @IBOutlet weak var noteDesc: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(tappedSaveNote(sender:)))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(tappedCancelNote(sender:)))
    }
    
    @objc func tappedSaveNote(sender: UIBarButtonItem) {
        let title = noteTitle.text ?? ""
        var desc = noteDesc.text ?? ""
        if !title.isEmpty {
            if desc == "New note..." {
                desc = ""
            }
            let newNote = Note(context: outputVC.context)
            newNote.title = title
            newNote.descriptionText = desc
            newNote.creationData = Date.now
            outputVC.saveChanges()
        }
        self.navigationController?.popViewController(animated: true)
    }
    @objc func tappedCancelNote(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
}
