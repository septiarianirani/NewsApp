//
//  SourceTableViewCell.swift
//  NewsApp
//
//  Created by Mac on 25/09/24.
//

import UIKit

class SourceTableViewCell: UITableViewCell {

    @IBOutlet var sourceNameLabel: UILabel!
    @IBOutlet var sourceDescLabel: UILabel!
    
    var sourceData: NewsSourceModel? {
        didSet {
            guard let data = sourceData else { return }
            
            sourceNameLabel.text = data.name
            sourceDescLabel.text = data.descriptionSource
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
