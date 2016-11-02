//
//  PlaylistDetailVC.swift
//  iAlhan
//
//  Created by ARSANI SIDAROUS on 10/30/16.
//  Copyright © 2016 alhan.org. All rights reserved.
//

import UIKit

struct PlaylistHymns{
    
    var HymnName: String!
    var HymnID: Int!
    var HymnURL: String!
}

class PlaylistDetailVC:  UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var PlayPauseButton: UIBarButtonItem!
    @IBOutlet var plDetail: UITableView!
    
    var playlistHymns:[PlaylistHymns]!
    
    var hymnURLS = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plDetail.delegate = self
        plDetail.dataSource = self
        
       
        
        playlistHymns = []

        if let array = PL_DBManager.shared.getPLHymns(playlist: self.title!) {
            
            playlistHymns = array

        }
            //print("\(playlistHymns.count)")
        // Do any additional setup after loading the view.
        
        for playlistHymn in playlistHymns {
            
            hymnURLS.append(URL(string: playlistHymn.HymnURL)!)
        }
//
        print("HYMN URLS: \(hymnURLS)")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("No of rows: \(playlistHymns.count)!")
        var noOfRows: Int = 0
        
        if (playlistHymns.count) > 0{
            noOfRows = (playlistHymns.count)
        }
        
        return noOfRows
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hymnCell", for: indexPath) 
        
        let row = indexPath.row
        
        print("just outside")
        if ((playlistHymns.count) > 0)
        {
            print("Got in")
            cell.textLabel?.text = playlistHymns[row].HymnName
        }
        
        
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            let row = indexPath.row
            PL_DBManager.shared.removeHymnsFromPL(hymnID: self.playlistHymns[row].HymnID)
            self.playlistHymns.remove(at: row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        
        return [delete]
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Audio controls
    @IBAction func Play(_ sender: AnyObject) {
        playButtonTapped()
        
        
    }
    
    func playButtonTapped() {
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: nil), animated: true)
        for hymnURL in hymnURLS{
            print("HYMN URL TO PLAY: \(hymnURL)")
            AlhanPlayer.sharedInstance.playQueue(playerURL: hymnURL)
            
            //AlhanPlayer.sharedInstance.playWithURL(playableURL: hymnURL)
        }
        //play()
        //print("%%% from PLAY \(AlhanPlayer.sharedInstance.player.rate)")
        
        
    }

}