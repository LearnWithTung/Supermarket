//
//  ItemCollectionViewCell.swift
//  Supermarket
//
//  Created by ThangLai on 08/12/2 Reiwa.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgItem: UIImageView!
    static let identifier = "ItemCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 9
        self.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
        // Initialization code
    }
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

}
