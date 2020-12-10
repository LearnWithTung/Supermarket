//
//  menuCollectionViewCell.swift
//  Supermarket
//
//  Created by namtrinh on 08/12/2020.
//

import UIKit

class menuCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var item: UIImageView!
    static let identifier = "menuCollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .systemGray4
    }
    
    static func nib()-> UINib {
        return UINib(nibName: "menuCollectionViewCell", bundle: nil)
    }
}
