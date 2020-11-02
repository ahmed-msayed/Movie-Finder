//
//  ViewController.swift
//  Movies Finder
//
//  Created by Ahmed Sayed on 7/21/20.
//  Copyright © 2020 Ahmed Sayed. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var table: UITableView!
    @IBOutlet var field: UITextField!
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        table.delegate = self       //to fire actions in our custom table class
        table.dataSource = self
        field.delegate = self
    }

    //Field, after entering text and click or leave text, call func then leave
    //textbox after keyboard closes
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()
        return true
    }
    
    func searchMovies() {
        //close keyboard if opened
        field.resignFirstResponder()
        //check field is not empty
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        let query = text.replacingOccurrences(of: " ", with: "%20")
        
        movies.removeAll()
        
        //Network Request
        URLSession.shared.dataTask(with: URL(string: "http://www.omdbapi.com/?apikey=797017ec&s=\(query)&type=movie")!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            //convert
            var result: MovieResult?
            do {
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            }
            catch {
                print("error")
            }
            
            guard let finalResult = result else {
                return
            }
            
            //print("\(describing: finalResult.Search.first?.Title)")
            //update movies array
            let newMovies = finalResult.Search
            self.movies.append(contentsOf: newMovies)
            //refresh table, any UI updates should be wrapped with DispatchQueue
            DispatchQueue.main.async {
                self.table.reloadData()
            }
            
            
        }).resume()
    }
    
    //Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //show movie details
        let url = "https://www.imdb.com/title/\(movies[indexPath.row].imdbID)"
        let vc = SFSafariViewController(url: URL(string: url)!)
        present(vc, animated: true)
        
    }
    

}

