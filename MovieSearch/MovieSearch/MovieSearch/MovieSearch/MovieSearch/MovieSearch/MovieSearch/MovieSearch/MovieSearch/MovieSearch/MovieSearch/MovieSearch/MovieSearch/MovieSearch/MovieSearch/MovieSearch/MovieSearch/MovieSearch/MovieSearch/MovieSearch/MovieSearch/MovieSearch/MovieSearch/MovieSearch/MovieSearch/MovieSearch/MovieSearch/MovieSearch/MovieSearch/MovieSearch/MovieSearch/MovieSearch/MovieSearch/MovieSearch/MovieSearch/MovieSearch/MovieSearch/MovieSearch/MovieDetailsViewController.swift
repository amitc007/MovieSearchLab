//
//  MovieDetailsViewController.swift
//  MovieSearch
//
//  Created by ac on 3/12/17.
//  Copyright © 2017 amitc. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieDetailsLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var fullPlot: UIButton!
    
    
    var movieImage:UIImage?
    //var movieDetails:Movie?
    var imdbID:String?

    @IBAction func moviesfavSelection(_ sender: UISegmentedControl) {
    }
    
    @IBAction func fullPlotAction(_ sender: UIButton) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        moviePoster.image = movieImage
        //self.movieDetailsLabel.text = "\nBefore datatask"
        getMovieDetails(imdbID:(self.imdbID)!){
            self.movieDetailsLabel.text = $0
            print("self.movieDetailsLabel.text:\(self.movieDetailsLabel.text!)")
        }
        
        
        print("Exiting viewDidLoad")
    }

    
    func getMovieDetails(imdbID:String, completion:@escaping (String)->() ) {
        
       print("In getMovieDetails imdbID:\(imdbID)")
        var text = String()
        guard let url = URL(string: "http://www.omdbapi.com/?i=\(imdbID)") else { fatalError("Invalid URL:") }
        let datatask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            //serialize
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            print("In getMovieDetails json:\(json)")
            let tmpMovie = Movie(dictionary: json as! [String : String])


            text =  "\n\n\(tmpMovie.plot)" +
            "\n\nRELEASED: \(tmpMovie.released)" +
            "\nDIRECTOR: \(tmpMovie.director)" +
            "\nWRITER: \(tmpMovie.writer)" +
            "\nSTARS: \(tmpMovie.actors)" +
            "\n\nIMDB Score: \(tmpMovie.imdbRating)" +
            "\nMetascore: \(tmpMovie.metascore)"
            
            self.navigationItem.title = tmpMovie.title
            self.fullPlot.titleLabel?.text = "FULL PLOT DESCRIPTION"
            
            completion(text)
//            DispatchQueue.main.async {
//                self.movieDetailsLabel.text = text
//                //self.movieDetailsLabel.text = self.getMovieDetails(imdbID: (self.imdbID)!)
//             }
        }
        datatask.resume()
        
        print("Exiting getMovieDetails")
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as? PlotSummaryViewController
        destVC?.imdbID = self.imdbID
    }
 

}
