//
//  Celda.swift
//  FirebaseCrude
//
//  Created by Fernando Jt on 6/5/18.
//  Copyright © 2018 Fernando Jumbo Tandazo. All rights reserved.
//

import UIKit

class Celda: UITableViewCell {

    @IBOutlet weak var imagenFirebase: UIImageView!
    @IBOutlet weak var nombreFirebase: UILabel!
    @IBOutlet weak var generoFirebase: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
