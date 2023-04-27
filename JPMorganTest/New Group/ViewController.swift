//
//  ViewController.swift
//  JPMorganTest
//
//  Created by Praveen Kumar on 27/04/23.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Constants
    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let fileName = "list.plist"
    private let networkManager = NetworkManager.instance
    
    // MARK: - Variables And Properties
    var planetsList: [Planet] = []
    private(set) var dataSource: [Planet] = []
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
        return recognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTabelViewCells()
        configureActivityLoader()
        self.loadLocalPlanetsList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadRemotePlanetsList()
    }
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Internal Methods
    private func registerTabelViewCells() {
        
        tableView.register(PlanetTableViewCell.self, forCellReuseIdentifier: String(describing: PlanetTableViewCell.self))
    }
    
    private func configureActivityLoader() {
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func saveLoacalPlanetsList() {
        
        let path = documentsPath.appendingPathComponent(fileName)
        do {
            let tempData = try JSONEncoder().encode(planetsList)
            try tempData.write(to: path)
        } catch {
            print("error")
        }
    }
    
    private func loadLocalPlanetsList() {
        
        let path = documentsPath.appendingPathComponent(fileName)
        if let data = NSData(contentsOf: path) as Data? {
            do {
                planetsList = try JSONDecoder().decode([Planet].self, from: data)
                dataSource = planetsList
            } catch {
                print("error")
            }
        }
    }
    
    private func loadRemotePlanetsList() {
        
        activityIndicator.startAnimating()
        let request = networkManager.createRequest(path: "planets/",
                                                  httpMethod: .get)
        networkManager.executeRequest(request: request,
                                         responseType: PlanetResult.self) { (result, errorString) in
            
            self.activityIndicator.stopAnimating()
            
            guard let result = result else {
                if let error = errorString {
                    let alert = UIAlertController(title: "Error",
                                                  message: error,
                                                  preferredStyle: .alert)
                    let alertCancelAction = UIAlertAction(title: "Cancel",
                                                          style: .destructive,
                                                          handler: nil)
                    let alertRetryAction = UIAlertAction(title: "Retry Again",
                                                         style: .default) { _ in
                        self.loadRemotePlanetsList()
                    }
                    alert.addAction(alertCancelAction)
                    alert.addAction(alertRetryAction)
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            self.planetsList = result.results
            self.dataSource = self.planetsList
            self.tableView.reloadData()
            self.saveLoacalPlanetsList()
        }
    }
}

// MARK: - Table view data source and delegate

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let planet = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlanetTableViewCell.self), for: indexPath) as! PlanetTableViewCell
        cell.configureLabelText(text: planet.name)
        return cell
    }
}

// MARK: - Search Bar Delegate

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        if let searchText = searchBar.text, !searchText.isEmpty {
            
            dataSource = planetsList.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        } else {
            dataSource = planetsList
        }
        tableView.reloadData()
        tableView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }

}

