//
//  DetailViewController.swift
//  SimpleTestflix
//
//  Created by Victor Valfre on 26/04/19.
//  Copyright © 2019 Victor Valfre. All rights reserved.
//

import Foundation
import UIKit

public class DetailViewController: UIViewController {

    public var movie: Movie?
    
    let movieLogoImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = UIView.ContentMode.scaleToFill
        imgView.clipsToBounds =  true
        imgView.backgroundColor = .red
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let dateTextView: UITextView = {
        let textView = UITextView()
        textView.text = "nome"
        textView.textColor = .white
        textView.backgroundColor = .darkGray
        textView.font = UIFont.boldSystemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let genderTextView: UITextView = {
        let textView = UITextView()
        textView.text = "nome"
        textView.textColor = .white
        textView.backgroundColor = .darkGray
        textView.font = UIFont.boldSystemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let nameTextView: UITextView = {
        let textView = UITextView()
        textView.text = "nome"
        textView.textColor = .white
        textView.backgroundColor = .darkGray
        textView.font = UIFont.boldSystemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let overviewTextView: UITextView = {
        let textView = UITextView()
        textView.text = "nome"
        textView.textColor = .white
        textView.backgroundColor = .darkGray
        textView.font = UIFont.boldSystemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .justified
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        setupNavigation()
        setupView()
    }
    
    func setupNavigation(){
        let navigationBarWidth = (navigationController?.navigationBar.frame.width)!
        let navigationBarHeigth = (navigationController?.navigationBar.frame.height)!
        let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: (navigationBarWidth * 0.6), height: navigationBarHeigth * 0.6))
        logo.image = UIImage(named: "testflix")
        logo.contentMode = .scaleAspectFit
        
        navigationItem.titleView = logo
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    func setupView(){
        view.addSubview(movieLogoImgView)
        view.addSubview(nameTextView)
        view.addSubview(dateTextView)
        view.addSubview(genderTextView)
        view.addSubview(overviewTextView)
        
        let url = movie!.posterPath != nil ? "https://image.tmdb.org/t/p/w185" + movie!.backDropPath! : ""
        if let imgUrl = URL(string: url) {
            movieLogoImgView.load(url: imgUrl)
        }
        
        nameTextView.text = movie!.title
        
        let df = DateFormatter()
        df.dateFormat = "dd/MM/YYYY"
        
        dateTextView.text = movie!.rDate != nil ? df.string(from: movie!.rDate!) : "NA"
        genderTextView.text = movie!.rGender != nil ? movie!.rGender!.joined(separator: ", ") : "NA"
        overviewTextView.text = movie!.overview
        
        setupLayout()
    }
    
    private func setupLayout(){
        let width = view.frame.width
        //let height = view.frame.height
        
        movieLogoImgView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        movieLogoImgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        movieLogoImgView.widthAnchor.constraint(equalToConstant: width).isActive = true
        movieLogoImgView.heightAnchor.constraint(equalToConstant: (width * (9/16))).isActive = true
        
        nameTextView.topAnchor.constraint(equalTo: movieLogoImgView.bottomAnchor, constant: 10).isActive = true
        nameTextView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        nameTextView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        dateTextView.topAnchor.constraint(equalTo: nameTextView.bottomAnchor, constant: 10).isActive = true
        dateTextView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dateTextView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        genderTextView.topAnchor.constraint(equalTo: dateTextView.bottomAnchor, constant: 10).isActive = true
        genderTextView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        genderTextView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        overviewTextView.topAnchor.constraint(equalTo: genderTextView.bottomAnchor, constant: 10).isActive = true
        overviewTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        overviewTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
    }
    
}
