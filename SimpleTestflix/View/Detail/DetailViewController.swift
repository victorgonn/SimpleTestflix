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
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        let width = view.frame.width
        let height = view.frame.height
        let header = UIView(frame: CGRect(x: 0, y: 0, width: width, height: (height * (9/20) + 20 + 20 + 50)))
        
        let imgView = UIImageView()
        imgView.backgroundColor = .red
        header.addSubview(imgView)
        
        let url = movie!.posterPath != nil ? "https://image.tmdb.org/t/p/w185" + movie!.backDropPath! : ""
        if let imgUrl = URL(string: url) {
            imgView.load(url: imgUrl)
        }
        
        
        let lbl = UILabel()
        lbl.text = "Titulo: " + self.movie!.title!
        lbl.textColor = .white
        lbl.backgroundColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textAlignment = .center
        header.addSubview(lbl)
        
        let df = DateFormatter()
        df.dateFormat = "dd/MM/YYYY"
        
        let lblDate = UILabel()
        lblDate.text = "Lançamento: " + (self.movie!.rDate != nil ? df.string(from: self.movie!.rDate!) : "NA")
        lblDate.textColor = .white
        lblDate.backgroundColor = .black
        lblDate.font = UIFont.boldSystemFont(ofSize: 14)
        lblDate.textAlignment = .center
        header.addSubview(lblDate)
        
        let lblSinopse = UILabel()
        lblSinopse.text = "Sinopse: " + self.movie!.overview!
        lblSinopse.textColor = .white
        lblSinopse.backgroundColor = .black
        lblSinopse.font = UIFont.boldSystemFont(ofSize: 14)
        lblSinopse.textAlignment = .justified
        lblSinopse.lineBreakMode = .byWordWrapping
        lblSinopse.numberOfLines = 0
        header.addSubview(lblSinopse)
        
        header.constraint(pattern: "H:|[v0]|", views: imgView, lbl, lblDate, lblSinopse)
        header.constraint(pattern: "V:|-90-[v0][v1(20)][v2][v3]|", views: imgView, lbl, lblDate, lblSinopse)
    
        view.addSubview(header)
    }
    
}
