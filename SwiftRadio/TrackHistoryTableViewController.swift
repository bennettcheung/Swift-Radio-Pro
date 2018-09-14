//
//  TrackHistoryTableViewController.swift
//  SwiftRadio
//
//  Created by Bennett on 2018-09-14.
//  Copyright © 2018 matthewfecher.com. All rights reserved.
//

import UIKit
import Firebase

class TrackHistoryViewController: UIViewController {

    var ref = Database.database().reference(withPath: "track-history")
    var trackHistory = [Track]()
    var uid = ""
  
  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    setupFirebaseUserListener()
    loadFirebaseData()

  }
  
  func setupFirebaseUserListener(){

    let user = Auth.auth().currentUser
    if let user = user {
      // The user's ID, unique to the Firebase project.
      // Do NOT use this value to authenticate with your backend server,
      // if you have one. Use getTokenWithCompletion:completion: instead.
      self.uid = user.uid
      self.ref = Database.database().reference(withPath: self.uid)
    }

  }
  
  func loadFirebaseData(){
    //add google observer
    ref.queryOrdered(byChild: "track").observe(.value, with: { snapshot in
      var newTracks: [Track] = []
      for child in snapshot.children {
        if let snapshot = child as? DataSnapshot,
          let track = Track(snapshot: snapshot) {
          newTracks.append(track)
        }
      }
      
      self.trackHistory = newTracks
      self.tableView.reloadData()
    })
  }

  // Mark: IB Actions
  
  @IBAction func closeButtonPressed(_ sender: Any) {
    
    self.dismiss(animated: true, completion: nil)
  }

  
}
extension TrackHistoryViewController: UITableViewDelegate, UITableViewDataSource{
  
  // MARK: - Table view data source
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return trackHistory.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TrackHistoryCell", for: indexPath)
    
    let track = trackHistory[indexPath.row]
    cell.textLabel!.text = track.artist
    cell.detailTextLabel!.text = track.title
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let track = trackHistory[indexPath.row]
    
    let shareMessage = "Artist: " + track.artist + "  Track: " + track.title
    
    let items = [shareMessage]
    let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
    present(ac, animated: true)
  }
}
