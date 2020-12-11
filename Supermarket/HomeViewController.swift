//
//  HomeViewController.swift
//  Supermarket
//
//  Created by namtrinh on 08/12/2020.
//

import UIKit

struct Food {
    let image: String
    let name: String
    let price: Int
}

class FoodItem {
    let food: Food
    var count: Int = 1
    
    init(food: Food) {
        self.food = food
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
    var itemChose = [FoodItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dummyData()
        menuCollectionView.register(menuCollectionViewCell.nib(), forCellWithReuseIdentifier: "menuCollectionViewCell")
        table.register(detailTableViewCell.nib(), forCellReuseIdentifier: "cell")
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        table.delegate = self
        table.dataSource = self
        menuCollectionView.backgroundColor = .systemGray6
        payoutButton.layer.cornerRadius = 9
        
    }
    
    fileprivate func dummyData() {
        foods.append(Food(image: "apple", name: "Apple", price: 35000))
        foods.append(Food(image: "aubergine", name: "Aubergine", price: 17000))
        foods.append(Food(image: "banana", name: "Banana", price: 15000))
        foods.append(Food(image: "beans", name: "Beans", price: 10000))
        foods.append(Food(image: "blueberries", name: "Blueberries", price: 65000))
        foods.append(Food(image: "bread", name: "Bread", price: 12000))
        foods.append(Food(image: "biscuit", name: "Biscuit", price: 21000))
        foods.append(Food(image: "broccoli", name: "Broccoli", price: 15000))
        foods.append(Food(image: "cabbage", name: "Cabbage", price: 10000))
    }
    
    @IBAction func handelClearBarButton(_ sender: UIBarButtonItem) {
        itemChose.removeAll()
        self.emptyLabel.isHidden = false
        updateTotal()
        table.reloadData()
    }
    func updateTotal(){
        total = 0
        for item in itemChose {
            total += item.food.price * item.count
        }
        result.text = vndFormatCurrency(total)
    }
    
    func checkName(newname : String) -> Bool{
        for item in itemChose {
            if item.food.name == newname {
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
        let selectedFood = foods[indexPath.item]
        addItem(selectedFood)
        self.emptyLabel.isHidden = true
        updateTotal()
        table.reloadData()
    }
    
    private func addItem(_ food: Food) {
        if checkName(newname: food.name) {
            itemChose.first(where: {$0.food.name == food.name })?.count += 1 //itemChoosed[indexPath.item].count + 1
        }
        else {
            itemChose.append(FoodItem(food: food))
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemChose.count
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
        cell.configure(foodItem: itemChose[indexPath.section])
        return cell
    }
}

extension HomeViewController: DetailTableViewCellDelegate {
    func increaseItem(_ foodItem: FoodItem) {
        foodItem.count += 1
        updateListFoodItem()
    }
    
    func decreaseItem(_ foodItem: FoodItem) {
        foodItem.count -= 1
        updateListFoodItem()
    }
    
    private func updateListFoodItem() {
        for item in itemChose{
            if item.count <= 0 {
                itemChose = itemChose.filter(){$0.food.name != item.food.name}
            }
        }
        table.reloadData()
        updateTotal()
    }
}
