//
//  ItemTableViewCell.swift
//  Supermarket
//
//  Created by ThangLai on 09/12/2 Reiwa.
//

import UIKit

protocol ItemCountDelegate {
//    func getItemCount(count: Int, name: String)
    
    func decreaseItem(_ foodItem: FoodItem)
    
    func increaseItem(_ foodItem: FoodItem)
    

}

class ItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var nameItemLabel: UILabel!
    @IBOutlet weak var priceItemLabel: UILabel!
    @IBOutlet weak var countItemLabel: UILabel!
    
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    var delegate: ItemCountDelegate?
    
    var foodItem: FoodItem!
    
    static let identifier = "ItemTableViewCell"
    var countItem: Int = 1
    override func awakeFromNib() {
        super.awakeFromNib()
        self.minusButton.layer.borderWidth = 1.0
        self.minusButton.layer.cornerRadius = 3
        self.minusButton.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.8745098039, blue: 0.3176470588, alpha: 1)
        self.imgItem.layer.cornerRadius = 9
        self.imgItem.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
//        self.countItemLabel.text = "\(countItem)"
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    public func configureCell(_ foodItem: FoodItem) {
        imgItem.image = foodItem.food.image
        nameItemLabel.text = foodItem.food.name
        priceItemLabel.text = String(foodItem.food.price)
        countItemLabel.text = String(foodItem.count)
        self.foodItem = foodItem
    }
    
    
    @IBAction func addItemPressed(_ sender: Any) {
//        countItem = countItem + 1
//        self.countItemLabel.text = "\(countItem)"
//        delegate.getItemCount(count: countItem, name: nameItemLabel.text!)
        delegate?.increaseItem(foodItem)


    }
    
    @IBAction func rmvItemPressed(_ sender: Any) {
//        if countItem > 0 {
//            countItem = countItem - 1
//            self.countItemLabel.text = "\(countItem)"
//            delegate.getItemCount(count: countItem, name: nameItemLabel.text!)
//        }
        delegate?.decreaseItem(foodItem)
    }
    
    

}
