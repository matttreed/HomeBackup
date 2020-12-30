//
//  IdeasTableViewController.swift
//  Home
//
//  Created by Matthew Reed on 12/28/20.
//

import UIKit
import CoreData

class IdeasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var headTableCell: UIView!
    
    @IBOutlet weak var ideasTable: UITableView!
    
    @IBOutlet weak var NewIdeaContainer: UIStackView!
    
    @IBOutlet weak var addNewIdeaContainer: UIView!
    
    @IBOutlet weak var ideaContainer: UIView!
    
    @IBOutlet weak var addExplanationContainer: UIView!
    
    @IBOutlet weak var explanationContainer: UIView!
    
    @IBOutlet weak var playlistContainer: UIView!
    
    @IBOutlet weak var addCancelContainer: UIStackView!
    
    @IBOutlet weak var ideaTextView: UITextView!
    
    @IBOutlet weak var explanationTextView: UITextView!
    
    @IBOutlet weak var addExplanationButton: UIButton!
    
    
    
    // RAM storage for list of ideas
    var ideasArray = [Idea]()
    
    // variables that describe which idea is selected
    var selectedIndex = 0
    var isNewIdea = true
    
    let defaults = UserDefaults.standard
    
    var selectedPlaylist: String? = nil
    
    // context for Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ideasTable.delegate = self
        ideasTable.dataSource = self
        
         NewIdeaContainer.layer.cornerRadius = 10
        
        
        if (defaults.integer(forKey: K.UserDefaults.numberOfIdeas) == 0) {
            // initializes number of ideas created at zero
            defaults.set(0, forKey: K.UserDefaults.numberOfIdeas)
        }
        
        resetAddNewIdea()
        
        NewIdeaContainer.layer.borderWidth = 1
        NewIdeaContainer.layer.borderColor = UIColor.systemGray2.cgColor
        
        loadData()
        
        headTableCell.frame.size.height = 70
        
        ideasTable.estimatedRowHeight = 100
        ideasTable.rowHeight = UITableView.automaticDimension
    }
    
    
    @IBAction func addNewIdeaPressed(_ sender: UIButton) {
        addNewIdeaContainer.isHidden = true
        addNewIdeaContainer.isHidden = true
        ideaContainer.isHidden = false
        addExplanationContainer.isHidden = false
        playlistContainer.isHidden = false
        addCancelContainer.isHidden = false
        
        self.headTableCell.frame.size.height = 225
        
        ideasTable.reloadData()
        
    }
    

    @IBAction func addExplanationPressed(_ sender: UIButton) {
        //addExplanationContainer.isHidden = true
        explanationContainer.isHidden = false
        
        addExplanationButton.titleLabel?.text = ""
        
        self.headTableCell.frame.size.height = 275
        //ideasTable.reloadData()
    }
    
    @IBAction func addToPlaylistPressed(_ sender: Any) {
        performSegue(withIdentifier: K.segues.pickPlaylist, sender: self)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        // initialize new idea
        let newIdea = Idea(context: self.context)
        newIdea.idea = ideaTextView.text
        newIdea.explanation = explanationTextView.text;
        if newIdea.idea == "" {
            newIdea.idea = nil
        }
        newIdea.id = Int64(defaults.integer(forKey: K.UserDefaults.numberOfIdeas) + 1)
        
        newIdea.playlist = selectedPlaylist
        
        // increase numIdeas
        defaults.set(newIdea.id, forKey: K.UserDefaults.numberOfIdeas)
        self.ideasArray.insert(newIdea, at: 0)
        saveData()
        ideasTable.reloadData()
        resetAddNewIdea()
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        resetAddNewIdea()
    }
    
    func resetAddNewIdea() {
        addNewIdeaContainer.isHidden = false
        ideaContainer.isHidden = true
        addExplanationContainer.isHidden = true
        explanationContainer.isHidden = true
        playlistContainer.isHidden = true
        addCancelContainer.isHidden = true
        
        ideaTextView.text = ""
        explanationTextView.text = ""
        
        headTableCell.frame.size.height = 100
        
        ideasTable.reloadData()
    }
    
    
    
    
    
    
    
    
    
    
    
    

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ideasArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.protoypes.idea, for: indexPath)
        
        cell.textLabel?.text = ideasArray[indexPath.row].idea
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isNewIdea = false
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: K.segues.editIdea, sender: self)
    }
    
    //MARK: - Handle Add New Idea

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == K.segues.editIdea) {
            let destination = segue.destination as! EditIdeaViewController
            destination.parentVC = self
        } else if (segue.identifier == K.segues.pickPlaylist) {
            let destination = segue.destination as! PlaylistPickerViewController
            destination.parentVC = self
            destination.passedPlaylist = ideasArray[selectedIndex].playlist
        }
        // presents ideas fullscreen, without gap at top
        
    }
    
    //MARK: - Handle Core Data
    
    func saveData() {
        // "commit" context to database
        do {
            try context.save()
        } catch {
            print("Error Saving Context \(error)")
        }
    }
    
    func loadData() {
        // pull data from database and sort according to id
        let request: NSFetchRequest<Idea> = Idea.fetchRequest()
        do {
            let unsortedArray = try context.fetch(request)
            // sorts notes in chronological order
            ideasArray = unsortedArray.sorted(by: { (a, b) -> Bool in
                return a.id > b.id
            })
        } catch {
            print("Error loading \(error)")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
