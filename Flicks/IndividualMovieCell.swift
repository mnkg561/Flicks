//
//  MovieCellTableViewCell.swift
//  Flicks
//
//  Created by Mogulla, Naveen on 3/31/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class IndividualMovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    
    @IBOutlet weak var moviePoster: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
