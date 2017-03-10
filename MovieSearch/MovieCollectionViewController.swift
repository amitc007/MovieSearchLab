//
//  MovieCollectionViewController.swift
//  MovieSearch
//
//  Created by ac on 3/10/17.
//  Copyright © 2017 amitc. All rights reserved.
//

import UIKit

private let reuseIdentifier = "movieCell"

class MovieCollectionViewController: UICollectionViewController {
    
    var movieItems: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes

        // Do any additional setup after loading the view.
        print("In viewDidLoad")
        getMovies(searchString: "Titanic")
        self.collectionView?.reloadData()
    }
    
    func getMovies(searchString:String) {
        print("In getMovies")
        let url = URL(string:"http://www.omdbapi.com/?t=\(searchString)")
        let session = URLSession.shared
        guard let unwrappedUrl = url else {print("Invalid unwrappedUrl") ; return }
        let task = session.dataTask(with: unwrappedUrl) { (data, response, error) in
            guard let data = data else { print("Invalid data") ; return }
            guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:String] else { return }
            
            let movie = Movie(dictionary: jsonData)
            
            guard let unwrappedPosterURL = URL(string: movie.posterURL) else { return }
            print("Poster URL: \(unwrappedPosterURL)")
            let dataURL = session.dataTask(with: unwrappedPosterURL, completionHandler: { (data, _, _) in
                guard let posterData = data else { print("posterData not found") ; return }
                print(posterData)
                //DispatchQueue.main.async() { () -> Void in
                    let image =  UIImage(data: posterData)
                    movie.poster = image
                    
                //}
                //movie.poster = UIImage(data: posterData)
                self.movieItems.append(movie)
                self.collectionView?.reloadData()
                print("jsonData:\(movie.poster)")
            })
            dataURL.resume()
            
            
        }
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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource



    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print("movieItems.count:\(movieItems.count)")
        return movieItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
        cell.moviePoster.image = movieItems[indexPath.row].poster
        cell.backgroundColor = UIColor.blue
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
