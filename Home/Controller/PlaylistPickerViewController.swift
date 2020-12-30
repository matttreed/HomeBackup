//
//  PlaylistPickerViewController.swift
//  Home
//
//  Created by Matthew Reed on 12/29/20.
//

import UIKit
import CoreData


class PlaylistPickerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var playlistPickerTable: UITableView!
    
    
    
    
    
    var parentVC: IdeasViewController? = nil
    
    var context: NSManagedObjectContext? = nil
    
    var playlistArray = [Playlist]()
    
    var passedPlaylist: String? = nil
    
    var selectedPlaylist: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = parentVC?.context
        playlistPickerTable.layer.cornerRadius = 10
        
        playlistPickerTable.dataSource = self
        playlistPickerTable.delegate = self
        
        addNewPlaylist(title: Date().description)
        loadData()
    }
    
    func addNewPlaylist(title: String) {
        let playlist = Playlist(context: context!)
        playlist.title = title
        saveData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.protoypes.playlist, for: indexPath)
        
        if indexPath.row == selectedPlaylist {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = playlistArray[indexPath.row].title
        return cell
    }

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        if selectedPlaylist != nil {
            parentVC?.selectedPlaylist = playlistArray[selectedPlaylist!].title
        } else {
            parentVC?.selectedPlaylist = nil
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedPlaylist == indexPath.row {
            selectedPlaylist = nil
        } else {
            selectedPlaylist = indexPath.row
        }
        tableView.deselectRow(at: indexPath, animated: true)
        if let index = selectedPlaylist {
            parentVC?.ideasArray[parentVC!.selectedIndex].playlist = playlistArray[index].title
        } else {
            parentVC?.ideasArray[parentVC!.selectedIndex].playlist = nil
        }
        
        playlistPickerTable.reloadData()
    }
    
    
    func saveData() {
        // "commit" context to database
        do {
            try context?.save()
        } catch {
            print("Error Saving Context \(error)")
        }
    }
    
    func loadData() {
        // pull data from database and sort according to id
        let request: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        do {
            playlistArray = try context!.fetch(request)
        } catch {
            print("Error loading \(error)")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
