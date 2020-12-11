//
//  detailTableViewCell.swift
//  Supermarket
//
//  Created by namtrinh on 08/12/2020.
//

import UIKit

class detailTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    var x: Int = 1
    var delegate: DetailTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        img.layer.cornerRadius = 9
        minus.layer.borderWidth = 1
        minus.layer.cornerRadius = 3
        plus.layer.borderWidth = 1
        plus.layer.cornerRadius = 3
        plus.backgroundColor = .green
        number.text = "1"
        plus.layer.borderColor = UIColor.green.cgColor
        minus.layer.borderColor = UIColor.green.cgColor
      
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            
        }
    }
    static func nib()-> UINib {
        return UINib(nibName: "detailTableViewCell", bundle: nil)
    }
    
    var foodItem: FoodItem!
    
    public func configure(foodItem: FoodItem) {
        img.image = UIImage(named: foodItem.food.image)
        name.text = foodItem.food.name
        price.text = vndFormatCurrency(foodItem.food.price)
        number.text = String(foodItem.count)
        self.foodItem = foodItem
    }
    
    func vndFormatCurrency(_ inputNumber: Int, symbol: String = "VND") -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.currencyGroupingSeparator = "."
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = ""
        currencyFormatter.positiveFormat = "#,##0 ¤"
        let priceString = currencyFormatter.string(from: NSNumber(value: inputNumber))!
        return priceString
    }

    @IBAction func handelMinusButton(_ sender: UIButton) {
        delegate?.decreaseItem(foodItem)
        
    }
    
    @IBAction func handelPlusButton(_ sender: UIButton) {
        delegate?.increaseItem(foodItem)
    }
}

protocol DetailTableViewCellDelegate {
    func increaseItem(_ foodItem: FoodItem)
    func decreaseItem(_ foodItem: FoodItem)
}
