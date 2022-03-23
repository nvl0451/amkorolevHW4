//
//  ViewController.swift
//  amkorolevHW4
//
//  Created by Андрей Королев on 19.03.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var emptyCollectionLabel: UILabel!
    
    @IBOutlet weak var notesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notesCollectionView.delegate = self
        notesCollectionView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNote(sender:)))
    }
    
    @objc func createNote(sender: UIBarButtonItem) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "NoteViewController") else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCell", for: indexPath) as! NoteCell
        cell.title.text = "Breathe in"
        cell.desc.text = "Breathe out"
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
    
    @IBOutlet weak var noteTitle: UITextField!
    
    @IBOutlet weak var noteDesc: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(tappedSaveNote(sender:)))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(tappedCancelNote(sender:)))
        
        
    }
    
    @objc func tappedSaveNote(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func tappedCancelNote(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
}
