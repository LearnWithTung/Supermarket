//
//  ItemTableViewCell.swift
//  Supermarket
//
//  Created by ThangLai on 09/12/2 Reiwa.
//

import UIKit

protocol ItemCountDelegate {
    func getItemCount(count: Int, name: String)
}

class ItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var nameItemLabel: UILabel!
    @IBOutlet weak var priceItemLabel: UILabel!
    @IBOutlet weak var countItemLabel: UILabel!
    
    var delegate: ItemCountDelegate!
    
    static let identifier = "ItemTableViewCell"
    var countItem: Int = 1
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgItem.layer.cornerRadius = 9
        self.imgItem.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
        self.countItemLabel.text = "\(countItem)"
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    
    @IBAction func addItemPressed(_ sender: Any) {
        countItem = countItem + 1
        self.countItemLabel.text = "\(countItem)"
        delegate.getItemCount(count: countItem, name: nameItemLabel.text!)
//        let indexP = NSIndexPath(item: countItemLabel.tag, section: 0)
//        print(indexP)

    }
    
    @IBAction func rmvItemPressed(_ sender: Any) {
        if countItem > 0 {
            countItem = countItem - 1
            self.countItemLabel.text = "\(countItem)"
            delegate.getItemCount(count: countItem, name: nameItemLabel.text!)
        }

    


    }
    
    

}
