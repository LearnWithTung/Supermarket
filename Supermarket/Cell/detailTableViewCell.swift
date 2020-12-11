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
    var delegate: detailTableViewCellDelegate?
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
    
    public func configure(food: Food) {
        img.image = UIImage(named: food.image)
        name.text = food.name
        price.text = vndFormatCurrency(food.price)
        number.text = String(food.count)
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
        if let a = number.text, let b = name.text {
            x = Int(a) ?? 0
            x -= 1
            number.text = String(x)
            delegate?.pass(name:b ,data: x)
        }
        
    }
    
    @IBAction func handelPlusButton(_ sender: UIButton) {
        if let a = number.text, let b = name.text {
            x = Int(a) ?? 0
            x += 1
            number.text = String(x)
            delegate?.pass(name:b ,data: x)
        }
    }
}

protocol detailTableViewCellDelegate {
    func pass(name:String, data: Int)
}
