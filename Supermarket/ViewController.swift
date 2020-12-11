//
//  ViewController.swift
//  Supermarket
//
//  Created by ThangLai on 08/12/2 Reiwa.
//

import UIKit

class Item {
    let image: UIImage
    let price: Int
    let name: String
    var itemCount: Int?
    init(image: UIImage, price: Int, name: String, itemCount: Int?) {
        self.image = image
        self.price = price
        self.name = name
        self.itemCount = itemCount
    }
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var itemArray: [Item] = [
        Item(image: #imageLiteral(resourceName: "apple-1 1"), price: 35000, name: "Apple", itemCount: 1),
        Item(image: #imageLiteral(resourceName: "broccoli 1"), price: 15000, name: "Broccoli", itemCount: 1),
        Item(image: #imageLiteral(resourceName: "banana 1"), price: 15000, name: "Banana", itemCount: 1),
        Item(image: #imageLiteral(resourceName: "bread 1"), price: 12000, name: "Bread", itemCount: 1),
        Item(image: #imageLiteral(resourceName: "aubergine 1"), price: 17000, name: "Aubergine", itemCount: 1),
        Item(image: #imageLiteral(resourceName: "blueberries 1"), price: 65000, name: "Bluberries", itemCount: 1),
        Item(image: #imageLiteral(resourceName: "cabbage 1"), price: 10000, name: "Cabbage", itemCount: 1),
        Item(image: #imageLiteral(resourceName: "beans 1"), price: 10000, name: "Beans", itemCount: 1),
        Item(image: #imageLiteral(resourceName: "biscuit 1"), price: 21000, name: "Biscuit", itemCount: 1)
    ]
    
    var itemPurchase: [Item] = []

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
            if let itemCount = item.itemCount {
                totalPrice = totalPrice + item.price * itemCount
            }
            else {
                totalPrice = totalPrice + item.price * 1
            }
            
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
        addItem(indexPath)
        updateTotalPrice()
    }
    
    private func addItem(_ indexPath: IndexPath) {
        if !self.idxCollectionViewCell.contains(indexPath.item) {
            self.idxCollectionViewCell.append(indexPath.item)
            self.itemPurchase.append(itemArray[indexPath.item])
            self.itemTableView.reloadData()
            //            updateTotalPrice()
            //            print(self.idxCollectionViewCell)
        } else {
            if let idx = self.idxCollectionViewCell.firstIndex(of: indexPath.item){
                let indexPath = IndexPath(row: idx, section: 0)
                let cell = itemTableView.cellForRow(at: indexPath) as! ItemTableViewCell
                self.itemPurchase[idx].itemCount! += 1
                cell.countItem = self.itemPurchase[idx].itemCount!
                cell.countItemLabel.text = "\(self.itemPurchase[idx].itemCount!)"
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
        cell.imgItem.image = self.itemPurchase[indexPath.row].image
        cell.nameItemLabel.text = self.itemPurchase[indexPath.row].name
        let money = formatCurrency(self.itemPurchase[indexPath.row].price)
        let end = money.index(money.endIndex, offsetBy: -3)
        let result = money[..<end]
        cell.priceItemLabel.text = "\(result)/kg"
        cell.countItemLabel.text = "\(self.itemPurchase[indexPath.row].itemCount!)"
        cell.countItem = self.itemPurchase[indexPath.row].itemCount!
//        cell.priceItemLabel.text = "\(vndFormatCurrency(self.itemPurchase[indexPath.row].price)) /kg"
//        String(self.itemPurchase[indexPath.row].price)
//        cell.countItemLabel.text = "1"
//        self.itemPurchase[indexPath.row].itemCount = cell.countItem
//        print(cell.countItem)
//        print(cell.countItemLabel.text)
        updateTotalPrice()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension ViewController: ItemCountDelegate {
    func setItemCount(to count: Int, name: String) {
        if count == 0 {
            let idx = self.itemPurchase.firstIndex{$0.name == name}!
            self.idxCollectionViewCell.remove(at: idx)
            self.itemPurchase.removeAll(where: {$0.name == name })
            print(self.idxCollectionViewCell)
        }
        else {
            self.itemPurchase.first(where: {$0.name == name })?.itemCount = count
        }
        print("\(name) \(count)")
        self.itemTableView.reloadData()
        updateTotalPrice()
        

    }
    

    
    
}


