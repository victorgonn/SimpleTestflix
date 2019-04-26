//
//  MovieTableViewCell.swift
//  SimpleTestflix
//
//  Created by Victor Valfre on 25/04/19.
//  Copyright © 2019 Victor Valfre. All rights reserved.
//

import Foundation
import UIKit

//Classe responsavel por cada Linha da Tabela
public class MovieTableViewCell: UITableViewCell{
    
    var movie: Movie? {
        didSet{
            if(movie != nil){
                let url = movie!.posterPath != nil ? "https://image.tmdb.org/t/p/w185" + movie!.posterPath! : ""
                if let imgUrl = URL(string: url) {
                    setupImage(url: imgUrl)
                    setupDateTxt()
                    setupGenderTxt()
                    //setupView(url: imgUrl)
                }
            }
            
        }
    }

    public func setupImage(url: URL){
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleToFill
        imageView.clipsToBounds =  true
        imageView.backgroundColor = .red
        addSubview(imageView)
        imageView.load(url: url)
        constraint(pattern: "H:|[v0(90)]|", views: imageView)
        constraint(pattern: "V:|[v0]|", views: imageView)
    }
    
    public func setupDateTxt(){
        let df = DateFormatter()
        df.dateFormat = "dd/MM/YYYY"
        
        let labelDate = UILabel()
        labelDate.text = self.movie!.rDate != nil ? df.string(from: self.movie!.rDate!) : "NA"
        labelDate.textColor = .white
        labelDate.font = UIFont.boldSystemFont(ofSize: 14)
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelDate)
        constraint(pattern: "H:|-95-[v0]-10-|", views: labelDate)
        constraint(pattern: "V:|-20-[v0(40)]|", views: labelDate)
    }
    
    public func setupGenderTxt(){
        let labelGender = UILabel()
        labelGender.text = self.movie!.rGender != nil ? self.movie!.rGender!.joined(separator: ", ") : "NA"
        labelGender.textColor = .white
        labelGender.font = UIFont.boldSystemFont(ofSize: 14)
        labelGender.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelGender)
        constraint(pattern: "H:|-95-[v0]-10-|", views: labelGender)
        constraint(pattern: "V:|-60-[v0(40)]|", views: labelGender)
    }
    
    
    public func setupView(url: URL){
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleToFill
        imageView.clipsToBounds =  true
        imageView.backgroundColor = .red
        addSubview(imageView)
        imageView.load(url: url)
        
        let df = DateFormatter()
        df.dateFormat = "dd/MM/YYYY"
        
        let labelDate = UILabel()
        labelDate.text = self.movie!.rDate != nil ? df.string(from: self.movie!.rDate!) : "NA"
        labelDate.textColor = .white
        labelDate.font = UIFont.boldSystemFont(ofSize: 14)
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelDate)
        
        let labelGender = UILabel()
        labelGender.text = self.movie!.rGender != nil ? self.movie!.rGender!.joined(separator: ", ") : "NA"
        labelGender.textColor = .white
        labelGender.font = UIFont.boldSystemFont(ofSize: 14)
        labelGender.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelGender)
        
        constraint(pattern: "H:|[v0(90)]-[v1(==v0)]-[v2(==v0)]|", views: imageView, labelGender, labelDate)
        constraint(pattern: "V:|[v0][v1(20)]-[v2(==v1)]|", views: imageView, labelGender, labelDate)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
