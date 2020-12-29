//
//  ViewController.swift
//  Home
//
//  Created by Matthew Reed on 12/28/20.
//

import UIKit

class TitleScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        // next button goes to ideas screen
        performSegue(withIdentifier: K.segues.titleToIdeas, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // presents editIdea fullscreen, without gap at top
        let destination = segue.destination
        destination.modalPresentationStyle = .fullScreen
    }
    
}

