//
//  CatalogViewController.swift
//  SimpleTestflix
//
//  Created by Victor Valfre on 25/04/19.
//  Copyright © 2019 Victor Valfre. All rights reserved.
//

import Foundation
import UIKit

class CatalogViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    let cellId = "cellId"
    var genders: Genders = Genders()
    var movies: Movies = Movies()
    
    let dataFormat: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/YYYY"
        return df
    }()
    
    let tableVIew: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.grouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.backgroundColor = .darkGray
        tableView.separatorStyle = .none
        return tableView
    }()
    
    public var sortByDate: Bool = false {
        didSet{
            let sortButton = UIBarButtonItem(barButtonSystemItem: self.sortByDate ? .rewind : .fastForward, target: self, action: #selector(sort))
            sortButton.tintColor = .white
            navigationItem.leftBarButtonItem = sortButton
        }
    }
    

    public var loaded: Bool = false {
        didSet{
            self.movies.parseDate()
            self.movies.genders = self.genders.values
            self.movies.parseGender()
            
            DispatchQueue.main.async {
                self.loadView.removeFromSuperview()
                self.tableVIew.reloadData()
            }
        }
    }
    
    
    //Componente loader
    let loadView : UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        loader.backgroundColor = .black
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.startAnimating()
        return loader
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoading()
        tryFetchData()
        setupNavigation()
        setupCatalogTable()
    }
    
    //Constroi o componente de Loading
    private func setupLoading(){
        guard let window = UIApplication.shared.keyWindow else {return}
        
        //adicionando loading para carregar catalog
        window.addSubview(loadView)
        window.bringSubviewToFront(loadView)
        
        window.constraint(pattern: "H:|[v0]|", views: loadView) //Alinhamento Horizontal para loadView
        window.constraint(pattern: "V:|[v0]|", views: loadView) //Alinhamento Vertical para loadView
    }
    
    //Constroi a Barra de Navegacao
    private func setupNavigation(){
        let navigationBarWidth = (navigationController?.navigationBar.frame.width)!
        let navigationBarHeigth = (navigationController?.navigationBar.frame.height)!
        let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: (navigationBarWidth * 0.6), height: navigationBarHeigth * 0.6))
        logo.image = UIImage(named: "testflix")
        logo.contentMode = .scaleAspectFit
        
        navigationItem.titleView = logo
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.isTranslucent = true
         navigationController?.navigationBar.barStyle = .black
        
        let sortButton = UIBarButtonItem(barButtonSystemItem: self.sortByDate ? .rewind : .fastForward, target: self, action: #selector(sort))
        sortButton.tintColor = .white
        navigationItem.leftBarButtonItem = sortButton
    }
    
    private func setupCatalogTable(){
        //view
        view.backgroundColor = .darkGray
        
        //tableView
        tableVIew.delegate = self
        tableVIew.dataSource = self
        tableVIew.register(MovieTableViewCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableVIew)
        view.constraint(pattern: "H:|[v0]|", views: tableVIew) //Alinhamento Horizontal para loadView
        view.constraint(pattern: "V:|-100-[v0]|", views: tableVIew) //Alinhamento Vertical para loadView
    }
    
    
    public func tryFetchData() {
        self.loadGenderData(){
            (returnedValue) in
            
            print(returnedValue.values)
            self.genders =  returnedValue
            self.loadMoviesByPage(page: 1)
        };
    }
    
    public func loadGenderData(completionBlock: @escaping (Genders) -> Void) -> Void{
        let categoryUrl = "https://api.themoviedb.org/3/genre/movie/list?api_key=1f54bd990f1cdfb230adb312546d765d&language=pt-BR"
        guard let gendersUrl = URL(string: categoryUrl) else {return}
        
        URLSession.shared.dataTask(with: gendersUrl){ (data, response, err) in
            guard let data = data else {return}
            do{
                let genders = try JSONDecoder().decode(Genders.self, from: data)
                completionBlock(genders)
            }
            catch let jsonError {
                print(jsonError)
                completionBlock(Genders())
            }
        }.resume()
    }
    
    func loadMoviesByPage(page: Int) {
        let moviesUrl = "https://api.themoviedb.org/3/movie/upcoming?api_key=1f54bd990f1cdfb230adb312546d765d&language=pt-BR&page="
        guard let urlFilmes = URL(string: moviesUrl + String(page)) else {return}
        print("Carregando pagina :" + String(page))
        URLSession.shared.dataTask(with: urlFilmes){ (data, response, err) in
            guard let data = data else {return}
            do{
                let parsedMovies = try JSONDecoder().decode(Movies.self, from: data)

                if(parsedMovies.page! < parsedMovies.total_pages!){
                    self.movies.values?.append(contentsOf: parsedMovies.values!)
                    self.loadMoviesByPage(page: page + 1)
                }
                else {
                    self.bindResults()
                }
            }
            catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
    func bindResults() {
        print(self.movies.values!.count)
        self.loaded = true
    }
    
    @objc func sort(){
        self.sortByDate = !self.sortByDate
        self.movies.sortByDate(asc: self.sortByDate)
        DispatchQueue.main.async {
            self.tableVIew.reloadData()
        }
    }


}



//Extensao responsavel pela Tabela da tela Inicial
extension CatalogViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.movies.values?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
        headerView.backgroundColor = .darkGray
        
        if(self.movies.values != nil &&
            section <= self.movies.values!.count){
            let selectedMovie = self.movies.values![section]
            
            let labelTxt = UILabel(frame: .zero)
            labelTxt.textColor = .white
            labelTxt.font = UIFont.boldSystemFont(ofSize: 16)
            labelTxt.translatesAutoresizingMaskIntoConstraints = false
            labelTxt.textAlignment = .justified
            labelTxt.text = selectedMovie.title != nil ? selectedMovie.title : "Filme " + String(section)
            
            headerView.addSubview(labelTxt)
            
            labelTxt.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4).isActive = true
            labelTxt.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 8).isActive = true
            labelTxt.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -8).isActive = true
        }
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width: CGFloat = tableView.frame.width * 0.5 // 50% da largura da tela
        return width * (3/4)  // aspectio ratio
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MovieTableViewCell
        
        cell.backgroundColor = .darkGray
        cell.selectionStyle = UITableViewCell.SelectionStyle.none

        if(self.movies.values != nil &&
            indexPath.section <= self.movies.values!.count){
            let selectedMovie = self.movies.values![indexPath.section]
            
            
            let url = selectedMovie.posterPath != nil ? "https://image.tmdb.org/t/p/w185" + selectedMovie.posterPath! : ""
            if let imgUrl = URL(string: url) {
                cell.movieImgView.load(url: imgUrl)
            }
            
            cell.originalTitleTextView.text = selectedMovie.originalTitle != nil ? selectedMovie.originalTitle : ""
            cell.dateTextView.text = selectedMovie.rDate != nil ? dataFormat.string(from: selectedMovie.rDate!) : "NA"
            cell.genderTextView.text = selectedMovie.rGender != nil ? selectedMovie.rGender!.joined(separator: ", ") : "NA"
            cell.isFavorited = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.movie = self.movies.values![indexPath.section]
        self.navigationController?.pushViewController(detailVC, animated: false)
    }
    
}
