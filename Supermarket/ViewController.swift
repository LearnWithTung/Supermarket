//
//  ViewController.swift
//  Supermarket
//
//  Created by ThangLai on 08/12/2 Reiwa.
//

import UIKit

struct Food {
    let image: UIImage
    let price: Int
    let name: String
}

class FoodItem {
    let food: Food
    var count: Int = 1
    init(food: Food) {
        self.food = food
    }
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var itemArray: [Food] = [
        Food(image: #imageLiteral(resourceName: "apple-1 1"), price: 35000, name: "Apple"),
        Food(image: #imageLiteral(resourceName: "broccoli 1"), price: 15000, name: "Broccoli"),
        Food(image: #imageLiteral(resourceName: "banana 1"), price: 15000, name: "Banana"),
        Food(image: #imageLiteral(resourceName: "bread 1"), price: 12000, name: "Bread"),
        Food(image: #imageLiteral(resourceName: "aubergine 1"), price: 17000, name: "Aubergine"),
        Food(image: #imageLiteral(resourceName: "blueberries 1"), price: 65000, name: "Bluberries"),
        Food(image: #imageLiteral(resourceName: "cabbage 1"), price: 10000, name: "Cabbage"),
        Food(image: #imageLiteral(resourceName: "beans 1"), price: 10000, name: "Beans"),
        Food(image: #imageLiteral(resourceName: "biscuit 1"), price: 21000, name: "Biscuit")
    ]
    
    var itemPurchase = [FoodItem]()

    var idxCollectionViewCell: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemCollectionView.register(ItemCollectionViewCell.nib(), forCellWithReuseIdentifier: "ItemCollectionViewCell")
        itemTableView.register(ItemTableViewCell.nib(), forCellReuseIdentifier: ItemTableViewCell.identifier)
        itemTableView.delegate = self
        itemTableView.dataSource = self

//        itemCollectionView.register(UINib(nibName: "itemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "itemCollectionViewCell")
//        itemCollectionView.register(firstCollectionViewCell.nib(), forCellWithReuseIdentifier: "firstCollectionViewCell")
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        if itemPurchase.count == 0 {
            self.itemTableView.isHidden = true
            self.emptyLabel.isHidden = false
        }
        
        updateTotalPrice()

    }
    
    func updateTotalPrice() {
        var totalPrice = 0
        for item in itemPurchase {
            totalPrice += item.food.price * item.count
        }
        self.totalPriceLabel.text = formatCurrency(totalPrice)
    }
    

    
    @IBAction func clearItemPurchasePressed(_ sender: Any) {
        self.idxCollectionViewCell.removeAll()
        self.itemPurchase.removeAll()
        self.itemTableView.reloadData()
        self.emptyLabel.isHidden = false
        self.itemTableView.isHidden = true
        updateTotalPrice()
    }
    
    func formatCurrency(_ inputNumber: Int, symbol: String = "VND") -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.currencyGroupingSeparator = "."
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = symbol
        currencyFormatter.positiveFormat = "#,##0 ¤"
        let priceString = currencyFormatter.string(from: NSNumber(value: inputNumber))!
        return priceString
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(indexPath.item)
        self.emptyLabel.isHidden = true
        self.itemTableView.isHidden = false
        
        let selectedFood = itemArray[indexPath.item]
        addItem(selectedFood, indexPath.item)
       
        updateTotalPrice()


    }
    
    func addItem(_ food: Food, _ indexCollectionView: Int) {
        if !self.idxCollectionViewCell.contains(indexCollectionView) {
            self.idxCollectionViewCell.append(indexCollectionView)
            self.itemPurchase.append(FoodItem(food: food))

            self.itemTableView.reloadData()
            //            updateTotalPrice()
            //            print(self.idxCollectionViewCell)
        } else {
            if let idx = self.idxCollectionViewCell.firstIndex(of: indexCollectionView){
                let indexPath = IndexPath(row: idx, section: 0)
                let cell = itemTableView.cellForRow(at: indexPath) as! ItemTableViewCell
                self.itemPurchase[idx].count += 1
//                cell.countItem = self.itemPurchase[idx].itemCount!
//                cell.countItemLabel.text = "\(self.itemPurchase[idx].itemCount!)"
                self.itemTableView.reloadData()
            }
        }
    }
    
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        cell.imgItem.image = itemArray[indexPath.item].image
        return cell
    }

    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemPurchase.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as! ItemTableViewCell
        cell.delegate = self
        cell.configureCell(itemPurchase[indexPath.row])

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension ViewController: ItemCountDelegate {
 
    func decreaseItem(_ foodItem: FoodItem) {
        foodItem.count = foodItem.count - 1
        updateListFoodItem()
        
        
    }
    
    func increaseItem(_ foodItem: FoodItem) {
        foodItem.count = foodItem.count + 1
        updateListFoodItem()
        
    }
    
    private func updateListFoodItem() {
        for item in itemPurchase {
            if item.count == 0 {
                self.itemPurchase.removeAll(where: {$0.food.name == item.food.name })
            }

        }
        self.itemTableView.reloadData()
        updateTotalPrice()
    }
    
    
    
}


