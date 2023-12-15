//
//  SearchWeatherTableViewCell.swift
//  Weather
//
//  Created by Elamurugu on 13/12/23.
//

import UIKit

class SearchWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var desclabel: UILabel!
    @IBOutlet weak var condImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
