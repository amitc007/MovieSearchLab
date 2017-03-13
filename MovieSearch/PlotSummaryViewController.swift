//
//  PlotSummaryViewController.swift
//  MovieSearch
//
//  Created by ac on 3/13/17.
//  Copyright © 2017 amitc. All rights reserved.
//

import UIKit

class PlotSummaryViewController: UIViewController {

    @IBOutlet weak var plotSummaryOutlet: UILabel!
    
    
    var summaryText:String?
    var imdbID: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        plotSummaryOutlet.text = summaryText
        
        if let unwrappedImdbID = imdbID {
            getFullSummary(imdbID: unwrappedImdbID) { (plot) in
                self.plotSummaryOutlet.text = plot
            }
        }
        
        
        
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
    
    func getFullSummary(imdbID: String, completion: @escaping (String) -> ()) {
        let url = URL(string: "http://www.omdbapi.com/?i=\(imdbID)&plot=full")
        let session = URLSession.shared
        guard let unwrappedURL = url else { return }
        let task = session.dataTask(with: unwrappedURL) { (data, response, error) in
            guard let unwrapedData = data else { return }
            let json = try? JSONSerialization.jsonObject(with: unwrapedData, options: []) as! [String: String]
            guard let unwrappedJson = json else { return }
            let tempMovie: Movie = Movie(dictionary: unwrappedJson)
            print(tempMovie.plot)
            completion(tempMovie.plot)
            
        }
        task.resume()
        
        
    }
    
    
    
}
