//
//  HomeViewController.swift
//  Supermarket
//
//  Created by namtrinh on 08/12/2020.
//

import UIKit

class Food {
    let image: String
    let name: String
    let price: Int
    var count: Int
    init(image: String, name: String, price: Int, count: Int) {
        self.image = image
        self.name = name
        self.price = price
        self.count = count
    }
}

class HomeViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var payoutButton: UIButton!
    @IBOutlet weak var result: UILabel!
    
    var foods = [Food]()
    var total = 0
    var itemChoosed = [Food]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foods.append(Food(image: "apple", name: "Apple", price: 35000,count:1))
        foods.append(Food(image: "aubergine", name: "Aubergine", price: 17000,count:1))
        foods.append(Food(image: "banana", name: "Banana", price: 15000,count:1))
        foods.append(Food(image: "beans", name: "Beans", price: 10000,count:1))
        foods.append(Food(image: "blueberries", name: "Blueberries", price: 65000,count:1))
        foods.append(Food(image: "bread", name: "Bread", price: 12000,count:1))
        foods.append(Food(image: "biscuit", name: "Biscuit", price: 21000,count:1))
        foods.append(Food(image: "broccoli", name: "Broccoli", price: 15000,count:1))
        foods.append(Food(image: "cabbage", name: "Cabbage", price: 10000,count:1))
        menuCollectionView.register(menuCollectionViewCell.nib(), forCellWithReuseIdentifier: "menuCollectionViewCell")
        table.register(detailTableViewCell.nib(), forCellReuseIdentifier: "cell")
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        table.delegate = self
        table.dataSource = self
        menuCollectionView.backgroundColor = .systemGray6
        payoutButton.layer.cornerRadius = 9
        
    }
    @IBAction func handelClearBarButton(_ sender: UIBarButtonItem) {
        itemChoosed.removeAll()
        self.emptyLabel.isHidden = false
        updateTotal()
        table.reloadData()
    }
    func updateTotal(){
        total = 0
        for item in itemChoosed {
            total += item.price * item.count
        }
        result.text = vndFormatCurrency(total)
        //result.text = "\(total) VND"
    }
    func check(){
        for item in itemChoosed{
            if item.count <= 0 {
                itemChoosed = itemChoosed.filter(){$0.name != item.name}
            }
        }
        table.reloadData()
    }
    func checkName(newname : String) -> Bool{
        for item in itemChoosed {
            if item.name == newname {
                return true
            }
        }
        return false
    }
    func vndFormatCurrency(_ inputNumber: Int, symbol: String = "VND") -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.currencyGroupingSeparator = "."
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = "VND"
        currencyFormatter.positiveFormat = "#,##0 ¤"
        let priceString = currencyFormatter.string(from: NSNumber(value: inputNumber))!
        return priceString
    }
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 55, height: 55)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: menuCollectionViewCell.identifier, for: indexPath) as! menuCollectionViewCell
        cell.item.image = UIImage(named: foods[indexPath.row].image)
        cell.layer.cornerRadius = 8
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if checkName(newname: foods[indexPath.item].name) {
            itemChoosed.first(where: {$0.name == itemChoosed[indexPath.item].name })?.count = itemChoosed[indexPath.item].count + 1
        }
        else {
            itemChoosed.append(Food(image: foods[indexPath.item].image, name: foods[indexPath.item].name, price: foods[indexPath.item].price, count: foods[indexPath.item].count))
        }
        self.emptyLabel.isHidden = true
        updateTotal()
        table.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemChoosed.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 10))
        view.backgroundColor = .clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! detailTableViewCell
        cell.delegate = self
        cell.configure(food: itemChoosed[indexPath.section])
        return cell
    }
}

extension HomeViewController: detailTableViewCellDelegate {
    func pass(name: String, data: Int) {
        self.itemChoosed.first(where: {$0.name == name})?.count = data
        print(itemChoosed)
        updateTotal()
        check()
    }
    
}
