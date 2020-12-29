//
//  IdeasTableViewController.swift
//  Home
//
//  Created by Matthew Reed on 12/28/20.
//

import UIKit
import CoreData

class IdeasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ideasTable: UITableView!
    @IBOutlet weak var createNewIdeaButton: UIButton!
    
    var ideasArray = [Idea]()
    
    var selectedIndex = 0
    var isNewIdea = true
    
    let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ideasTable.delegate = self
        ideasTable.dataSource = self
        
        createNewIdeaButton.layer.cornerRadius = 10
        
        if (defaults.integer(forKey: K.UserDefaults.numberOfIdeas) == 0) {
            // runs only on first run of app
            defaults.set(0, forKey: K.UserDefaults.numberOfIdeas)
        }
        
        loadData()
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
        selectedIndex = indexPath.row
        isNewIdea = false
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: K.segues.editIdea, sender: self)
    }
    
    
    @IBAction func createNewIdeaPressed(_ sender: Any) {
        selectedIndex = 0
        isNewIdea = true
        let newIdea = Idea(context: self.context)
        newIdea.idea = ""
        newIdea.explanation = nil;
        newIdea.id = Int64(defaults.integer(forKey: K.UserDefaults.numberOfIdeas) + 1)
        defaults.set(newIdea.id, forKey: K.UserDefaults.numberOfIdeas)
        self.ideasArray.insert(newIdea, at: 0)
        performSegue(withIdentifier: K.segues.editIdea, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // presents ideas fullscreen, without gap at top
        let destination = segue.destination as! EditIdeaViewController
        destination.modalPresentationStyle = .fullScreen
        destination.parentVC = self
        
    }
    
    func saveData() {
        
        do {
            try context.save()
        } catch {
            print("Error Saving Context \(error)")
        }
    }
    
    func loadData() {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
