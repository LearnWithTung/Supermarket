//
//  Food.swift
//  Supermarket
//
//  Created by ThangLai on 31/12/2 Reiwa.
//

import Foundation
import UIKit

struct Food {
    let image: UIImage?
    let price: Int
    let name: String
}

class FoodItem {
    let food: Food
    var count: Int = 1
    init(food: Food, count: Int) {
        self.food = food
        self.count = count
    }
}

struct InvoiceSection {
    var datetime: String
    var invoice: [FoodItem]
}
