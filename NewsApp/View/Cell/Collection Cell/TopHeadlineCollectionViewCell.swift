//
//  TopHeadlineCollectionViewCell.swift
//  NewsApp
//
//  Created by Mac on 25/09/24.
//

import UIKit
import AlamofireImage

class TopHeadlineCollectionViewCell: UICollectionViewCell {

    @IBOutlet var newsContentView: UIView!
    @IBOutlet var newsImageView: UIImageView!
    @IBOutlet var newsTitleLabel: UILabel!
    @IBOutlet var newsDescriptionLabel: UILabel!
    @IBOutlet var newsDateLabel: UILabel!
    @IBOutlet var newsSourceLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    var headlineData: NewsItemModel? {
        didSet {
            print(headlineData?.title)
            guard let data = headlineData else {
                return
            }
            
            newsTitleLabel.text = data.title
            newsDescriptionLabel.text = data.descriptionNews
            newsSourceLabel.text = data.author
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z''"
            if let publishDateStr = data.publishedAt, let publishDate = dateFormatter.date(from: publishDateStr) as? Date{
                dateFormatter.dateFormat = "dd/MM/yyyy"
                newsDateLabel.text = dateFormatter.string(from: publishDate)
            }
            
            if let urlImage = data.urlToImage, let url = URL(string: urlImage) {
                newsImageView.af.setImage(withURL: url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        newsContentView.layer.cornerRadius = 6.0
    }

}
