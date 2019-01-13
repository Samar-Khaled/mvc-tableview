//
//  DreamsListTableViewController.swift
//  Ghost's Dreams
//
//  Created by Smsma Mac on 12/10/18.
//  Copyright © 2018 Samar Khaled. All rights reserved.
//

import UIKit
import os.log

class DreamsListTableViewController: UITableViewController , UISearchBarDelegate {

    //MARK: - Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    var allDreams = [Dream]()
    var displayedDreams = [Dream]()
    
     //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if  let dreams = loadDreams() {
            self.allDreams = dreams
            self.displayedDreams = allDreams
        }
        
        setUpSearchBar()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedDreams.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "DreamTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DreamTableViewCell else {
            return UITableViewCell()
        }

         let dream = displayedDreams[indexPath.row]
        
        cell.titleLable.text = dream.dreamTitle
        cell.descriptionLabel.text = dream.dreamDescription
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }
    
    // search bar in section header
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
    
    
    //MARK:  - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        displayedDreams = allDreams.filter({ dream -> Bool in
            if searchText.isEmpty { return true }
            return dream.dreamTitle.lowercased().contains(searchText.lowercased())
        })
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.endEditing(true)
    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.text = ""
//        displayedDreams = allDreams
//        tableView.reloadData()
//    }
  
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding new", log: OSLog.default, type: .debug)
        case "ShowDetails":
            guard let dreamViewController = segue.destination as? DreamViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? DreamTableViewCell else {
                fatalError("Unexpected Sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is in the table")
            }
            
            let dream = displayedDreams[indexPath.row]
            dreamViewController.dream = dream
            
             os_log("Show details", log: OSLog.default, type: .debug)
            
        default:
            os_log("unknown Segue Identifier", log: OSLog.default, type: OSLogType.debug)
        }
    }

    //MARK: - Actions
    
    @IBAction func unwindToDreamList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DreamViewController, let dream = sourceViewController.dream {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let beforeEditDream = displayedDreams[selectedIndexPath.row]
                displayedDreams[selectedIndexPath.row] = dream
                
                if let index = allDreams.index(of:beforeEditDream ) {
                
                    allDreams[index] = dream
                }
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new .
                let newIndexPath = IndexPath(row: displayedDreams.count, section: 0)
                
                allDreams.append(dream)
                displayedDreams.append(dream)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            saveDreams()
        }
            
    }
    
    //MARK: - Private methods
    
    private func saveDreams() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: allDreams, requiringSecureCoding: false)
            try data.write(to: Dream.ArchiveURL)
        } catch {
            os_log("Couldn't write file", log: OSLog.default, type: .debug)
        }
    }
    
    private func loadDreams() -> [Dream]?  {
        
        do {
            if let loadedMeals = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(Data.init(contentsOf: Dream.ArchiveURL)) as? [Dream] {
                return loadedMeals
            }
        } catch {
            os_log("Couldn't read file.", log: OSLog.default, type: .debug)
        }
        return nil
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self

    }
    
   
}
