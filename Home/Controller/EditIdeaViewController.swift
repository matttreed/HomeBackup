//
//  EditIdeaViewController.swift
//  Home
//
//  Created by Matthew Reed on 12/28/20.
//

import UIKit

class EditIdeaViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var groupTextView: UIView!
    @IBOutlet weak var ideaTextView: UITextView!
    @IBOutlet weak var explanationTextView: UITextView!
    @IBOutlet weak var addExplanationButton: UIButton!
    @IBOutlet weak var explanationTextViewContainer: UIView!
    
    let realmInterface = RealmInterface()
    
    
    // parentViewController used to access and manipulate data from IdeasTableViewController
    // this view controller acts as a child, doesn't store any data itself
    var parentVC: IdeasViewController? = nil
    var idea: Idea? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idea = parentVC?.ideasArray?[parentVC!.selectedIndex]
        ideaTextView.text = idea!.idea
        
        // either shows "add an explanation" button, or the explanation, never both
        if idea!.explanation == nil {
            explanationTextViewContainer.isHidden = true
        } else {
            addExplanationButton.isHidden = true
            explanationTextView.text = idea?.explanation!
        }
        
        groupTextView.layer.cornerRadius = 10
        groupTextView.layer.borderWidth = 1
        groupTextView.layer.borderColor = UIColor.systemGray2.cgColor
        
//        ideaTextView.textContainer.heightTracksTextView = true
//        ideaTextView.isScrollEnabled = false
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        idea!.idea = ideaTextView.text
        
        if explanationTextView.text == "" {
            // if explanation is empty, store as nil not ""
            idea!.explanation = nil
        } else {
            idea!.explanation = explanationTextView.text
        }
        parentVC?.ideasTable.reloadData()
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        if parentVC!.isNewIdea {
            //deleteIdea()
        }
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        //deleteIdea()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addExplanationButtonPressed(_ sender: UIButton) {
        explanationTextViewContainer.isHidden = false
        addExplanationButton.isHidden = true
    }
    
//    func deleteIdea() {
//        let ideaToRemove = parentVC!.ideasArray[parentVC!.selectedIndex]
//
//        // remove from RAM
//        parentVC?.ideasArray.remove(at: parentVC!.selectedIndex)
//        parentVC?.ideasTable.reloadData()
//
//        //remove from database
//        parentVC?.context.delete(ideaToRemove)
//        parentVC?.saveData()
//    }
}
