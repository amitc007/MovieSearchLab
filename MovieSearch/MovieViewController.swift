//
//  MovieViewController.swift
//  MovieSearch
//
//  Created by ac on 3/11/17.
//  Copyright © 2017 amitc. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController, UICollectionViewDelegate,UISearchBarDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    
    var movieItems: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        //searchBarOutlet.delegate = self     //
        collectionViewOutlet.delegate = self
        collectionViewOutlet.dataSource = self
        
        print("In viewDidLoad")
        // Do any additional setup after loading the view.
        //getMovies(searchString: "Titanic")
    }

   /* func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing:Search string:\(searchBar.text)")
        if let searchStrig = searchBar.text { getMovies(searchString: searchStrig) } else { print("No search string found") }
    }*/
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked:Search string:\(searchBar.text)")
        if let searchStrig = searchBar.text { getMovies(searchString: searchStrig) } else { print("No search string found") }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print("movieItems.count:\(movieItems.count)")
        return movieItems.count
    }
    

    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        cell.moviePoster.image = movieItems[indexPath.row].poster
        cell.backgroundColor = UIColor.blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth  = UIScreen.main.bounds.width
        let cellWidth = screenWidth/2 - 6
        
        let size = CGSize(width:cellWidth, height:cellWidth)
        print("\n**cell width:\(size)\n")
        return size
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedCell = collectionViewOutlet.indexPath(for: sender as! UICollectionViewCell )
        let destVC = segue.destination as? MovieDetailsViewController
        
        destVC?.movieImage =  movieItems[(selectedCell?.row)!].poster
        destVC?.imdbID = movieItems[(selectedCell?.row)!].imdbID
        
        print("row:\((selectedCell?.row)!) imdbID:\(destVC?.imdbID)")
        //destVC?.movieDetails = movieItems[(selectedCell?.row)!]     //object assignment dos not work
        //self.navigationItem.backBarButtonItem?.title = movieItems[(selectedCell?.row)!].title   //IMP
    }
   
    
    /* Ref:  http://www.omdbapi.com
     Get by search string (Title,imdbID,year,PosterURL  )  :        http://www.omdbapi.com/?s=starwars
     By imdbID (short plot , imdbID, title,year,writer,Actors,imdbRatings etc) :  http://www.omdbapi.com/?i=tt0076759
     By imdbID (full plot) :  http://www.omdbapi.com/?i=tt0076759&plot=full
     
     
     */
    func getMovies(searchString:String) {
        movieItems = []
        print("In getMovies")
        let url = URL(string:"http://www.omdbapi.com/?s=\(searchString)")
        let session = URLSession.shared
        guard let unwrappedUrl = url else {print("Invalid unwrappedUrl") ; return }
        
        //get json data
        let task = session.dataTask(with: unwrappedUrl) { (data, response, error) in
            guard let data = data else { print("Invalid data") ; return }
            
            guard let jsonData = try? JSONSerialization.jsonObject  (with: data, options: []) as? [String:Any]  else { print("Invalid jsonData"); return }
            
            guard let moviesDictArray = jsonData?["Search"] as? [[String:String]] else
            { print("Invalid moviesDictArray"); return }
            print("moviesDictArray:\(moviesDictArray)")
            
            for movieDict in moviesDictArray {
                let movie = Movie(dictionary: movieDict)
               // self.movieItems.append(movie)
                
                //2nd inner datatask to get Image
                //for movie in movieItems {
                    guard let unwrappedPosterURL = URL(string: movie.posterURL) else { return }
                    //print("Poster URL: \(unwrappedPosterURL)")
                    
                    let dataURL = session.dataTask(with: unwrappedPosterURL, completionHandler: { (data, _, _) in
                        guard let posterData = data else { print("posterData not found") ; return }
                        //print(posterData)
                        movie.poster =  UIImage(data: posterData)
                        
                        self.movieItems.append(movie)
                        DispatchQueue.main.async {
                             self.collectionViewOutlet?.reloadData()
                        }
                        
                        print("jsonData:\(movie.poster)")
                    }) //let dataURL
                    dataURL.resume()
                //} //for
            }
            
        } //task
        task.resume()
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
