//
//  TrackViewController.swift
//  ItunesSongs
//
//  Created by MAC on 01/04/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit

class TrackViewController: UIViewController {

    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var tracks:[Track]?
    
    let service:Service = Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TrackViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchedText = searchBar.text , searchedText.count > 0 {
            service.get(baseUrl:EndPoints.baseUrl.rawValue, path:EndPointsPath.search.rawValue, parameters:"media=music&entity=song&term=\(searchedText)", completion: { (tracks, error) in
                if let _error = error {
                    let alertViewController = UIAlertController(title:"Error", message:_error, preferredStyle: UIAlertControllerStyle.alert)
                    let alertAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.cancel, handler: { (alert) in
                        alertViewController.dismiss(animated:true, completion:nil)
                    })
                    alertViewController.addAction(alertAction)
                    self.present(alertViewController, animated:true, completion:nil)
                }
                    self.tracks = tracks
                    self.tracksTableView.reloadData()
                    self.searchBar.resignFirstResponder()
                
            })
        }
    }
}

extension TrackViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _tracks = self.tracks else {
            return 0
        }
        return _tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"trackCell", for:indexPath) as! TrackCell
        
        if let _tracks = self.tracks {
            let track = _tracks[indexPath.row]
            cell.trackNameLbl.text = track.trackName
            cell.trackArtistLbl.text = track.artistName
        }else {
            cell.trackNameLbl.text = ""
            cell.trackArtistLbl.text = ""
        }
        return cell
    }
    
    
}
