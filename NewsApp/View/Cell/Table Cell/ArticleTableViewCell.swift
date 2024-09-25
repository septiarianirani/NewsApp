//
//  ArticleTableViewCell.swift
//  NewsApp
//
//  Created by Mac on 25/09/24.
//

import UIKit
import AlamofireImage

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet var articleImageView: UIImageView!
    @IBOutlet var articleDateLabel: UILabel!
    @IBOutlet var articleTitleLabel: UILabel!
    @IBOutlet var articleSourceLabel: UILabel!
    @IBOutlet var articleDescriptionLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    var articleData: NewsItemModel? {
        didSet {
            guard let data = articleData else { return }
            
            articleTitleLabel.text = data.title
            articleSourceLabel.text = data.author
            articleDescriptionLabel.text = data.descriptionNews
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z''"
            if let publishDateStr = data.publishedAt, let publishDate = dateFormatter.date(from: publishDateStr) as? Date{
                dateFormatter.dateFormat = "dd/MM/yyyy"
                articleDateLabel.text = dateFormatter.string(from: publishDate)
            }
            
            if let urlImage = data.urlToImage, let url = URL(string: urlImage) {
                articleImageView.af.setImage(withURL: url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
