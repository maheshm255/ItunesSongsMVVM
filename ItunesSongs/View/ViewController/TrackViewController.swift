//
//  TrackViewController.swift
//  ItunesSongs
//
//  Created by MAC on 01/04/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit

protocol TrackViewControllerProttocol {
    func refreshUI()
    func showError(message:String)
}
class TrackViewController: UIViewController {
    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var trackViewModel:TrackViewModel<Service<Tracks>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        trackViewModel = TrackViewModel(trackViewController:self, service: Service())
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

extension TrackViewController: TrackViewControllerProttocol {
    func showError(message: String) {
        
        let alertViewController = UIAlertController(title:"Error", message:message, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.cancel, handler: { (alert) in
            alertViewController.dismiss(animated:true, completion:nil)
        })
        alertViewController.addAction(alertAction)
        self.present(alertViewController, animated:true, completion:nil)
    }

    func refreshUI() {
       self.tracksTableView.reloadData()
    }
}
extension TrackViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       trackViewModel?.searchTracks(searchText:searchBar.text)
    }
}

extension TrackViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackViewModel.numberOfTracks()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"trackCell", for:indexPath) as! TrackCell
        cell.trackNameLbl.text = trackViewModel.trackName(index:indexPath.row)
        cell.trackArtistLbl.text = trackViewModel.artistName(index:indexPath.row)
        return cell
    }
}
