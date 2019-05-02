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

    let movieImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = UIView.ContentMode.scaleToFill
        imgView.clipsToBounds =  true
        imgView.backgroundColor = .red
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let originalTitleTextView: UILabel = {
        let textView = UILabel()
        textView.text = "title"
        textView.textColor = .white
        textView.backgroundColor = .darkGray
        textView.font = UIFont.boldSystemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .justified
        textView.numberOfLines = 0
        return textView
    }()
    
    let dateTextView: UILabel = {
        let textView = UILabel()
        textView.text = "data"
        textView.textColor = .white
        textView.backgroundColor = .darkGray
        textView.font = UIFont.boldSystemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .justified
        textView.numberOfLines = 0
        return textView
    }()
    
    let genderTextView: UILabel = {
        let textView = UILabel()
        textView.text = "genero"
        textView.textColor = .white
        textView.backgroundColor = .darkGray
        textView.font = UIFont.boldSystemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .justified
        textView.numberOfLines = 0
        return textView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView(){
        addSubview(movieImgView)
        addSubview(originalTitleTextView)
        addSubview(dateTextView)
        addSubview(genderTextView)
        
        setupLayout()
    }
    
    private func setupLayout(){
        let width = self.frame.width
        
        movieImgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        movieImgView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        movieImgView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        movieImgView.widthAnchor.constraint(equalToConstant: ((width * 0.6) * (9/16))).isActive = true
        
        originalTitleTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        originalTitleTextView.leftAnchor.constraint(equalTo: movieImgView.rightAnchor, constant: 10).isActive = true
        originalTitleTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        
        dateTextView.topAnchor.constraint(equalTo: originalTitleTextView.bottomAnchor, constant: 10).isActive = true
        dateTextView.leftAnchor.constraint(equalTo: movieImgView.rightAnchor, constant: 10).isActive = true
        dateTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        
        genderTextView.topAnchor.constraint(equalTo: dateTextView.bottomAnchor, constant: 8).isActive = true
        genderTextView.leftAnchor.constraint(equalTo: movieImgView.rightAnchor, constant: 10).isActive = true
        genderTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
    }
    
}
