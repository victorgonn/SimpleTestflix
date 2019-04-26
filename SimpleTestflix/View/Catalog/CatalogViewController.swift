//
//  CatalogViewController.swift
//  SimpleTestflix
//
//  Created by Victor Valfre on 25/04/19.
//  Copyright © 2019 Victor Valfre. All rights reserved.
//

import Foundation
import UIKit

class CatalogViewController: UITableViewController {
    let cellId = "cellId"
    var genders: Genders = Genders()
    var movies: Movies = Movies()
    
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
                self.tableView?.reloadData()
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
        
        let sortButton = UIBarButtonItem(barButtonSystemItem: self.sortByDate ? .rewind : .fastForward, target: self, action: #selector(sort))
        sortButton.tintColor = .white
        navigationItem.leftBarButtonItem = sortButton
    }
    
    private func setupCatalogTable(){
        //tableView
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        //tableView.backgroundColor = .darkGray
        tableView.separatorStyle = .none
        
        //Table Header
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
            self.tableView?.reloadData()
        }
    }


}



//Extensao responsavel pela Tabela da tela Inicial
extension CatalogViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.movies.values?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.movies.values?[section].title ?? "Filme " + String(section)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width: CGFloat = tableView.frame.width * 0.4 // 40% da largura da tela
        return width * (3/4)  // aspectio ratio
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MovieTableViewCell
        
        //Limpando antes de reusar
        cell.contentView.subviews.forEach { (sbv) in
            sbv.removeFromSuperview()
        }
        
        cell.backgroundColor = .black
        cell.movie = self.movies.values![indexPath.section]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.movie = self.movies.values![indexPath.section]
        self.navigationController?.pushViewController(detailVC, animated: false)
    }
    
}
