//
//  firstCollectionViewCell.swift
//  PhotosPreview
//
//  Created by namtrinh on 04/12/2020.
//

import UIKit

class firstCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    
    static let identifier = "firstCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .systemGray5
        img.layer.cornerRadius = 30
    }
    
    static func nib()-> UINib {
        return UINib(nibName: "firstCollectionViewCell", bundle: nil)
    }

}
