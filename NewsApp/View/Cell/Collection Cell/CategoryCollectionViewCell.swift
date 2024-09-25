//
//  CategoryCollectionViewCell.swift
//  NewsApp
//
//  Created by Mac on 25/09/24.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet var categoryContentView: UIView!
    @IBOutlet var categoryNameLabel: UILabel!
    
    var categoryData: NewsCategory? {
        didSet {
            guard let data = categoryData else { return }
            
            categoryNameLabel.text = data.categoryTitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        categoryContentView.layer.cornerRadius = 4.0
        categoryContentView.layer.borderWidth = 1.0
        categoryContentView.layer.borderColor = UIColor.black.cgColor
    }

}
