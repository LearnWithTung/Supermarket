//
//  HistoryViewController.swift
//  Supermarket
//
//  Created by ThangLai on 30/12/2 Reiwa.
//

import UIKit
import Firebase
class HistoryViewController: UIViewController {
    
    @IBOutlet weak var historyTableView: UITableView!
    let db = Firestore.firestore()

    var refreshControl = UIRefreshControl()
    var sections = [InvoiceSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.register(ItemTableViewCell.nib(), forCellReuseIdentifier: ItemTableViewCell.identifier)
        historyTableView.delegate = self
        historyTableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.historyTableView.addSubview(refreshControl)
        fetchPurchaseHistory { (invoiceArray, error) in
            if let err = error {
                print(err)
            }
            self.sections = invoiceArray
            self.sections = self.sections.sorted { $0.datetime > $1.datetime}

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
                self?.historyTableView.reloadData()
            }
        }




    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.leftBarButtonItem = nil



        
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        self.sections.removeAll()
        self.historyTableView.reloadData()
        fetchPurchaseHistory { (invoiceArray, error) in

            if let err = error {
                print(err)
            }
//            invoiceArray = invoiceArray.sorted { }
            self.sections = invoiceArray
            self.sections = self.sections.sorted { $0.datetime > $1.datetime}
            
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
                self?.historyTableView.reloadData()
            }


        }

        refreshControl.endRefreshing()

    }
    
    func fetchPurchaseHistory(completion : @escaping([InvoiceSection], Error?) -> Void) {
//        self.arrDate = []
//        self.arrFoodItem = []
        var sections = [InvoiceSection]()
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        //order(by: "timestamp", descending: true)
        db.collection(uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    guard let timestamp = document.data()["timestamp"] as? Double else {
                        return
                    }
                    let date = NSDate(timeIntervalSince1970: timestamp)
                    let dayTimePeriodFormatter = DateFormatter()
                    dayTimePeriodFormatter.dateFormat = "MMM dd yyyy HH:mm:ss" //MMM dd yyyy hh:mm a
                    let dateString = dayTimePeriodFormatter.string(from: date as Date)
                    
//                    self.arrDate.append(document.data()["timestamp"] as! String)//document.documentID)
                    self.db.collection(uid).document(document.documentID).collection("items").getDocuments { (qrsnapshot, error) in
                        if let er = error {
                            print("Error getting documents: \(er)")
                        } else {
                            var invoice = [FoodItem]()
                            for subdoc in qrsnapshot!.documents {
                                let item = subdoc.data()
                                if let name = item["name"] as? String, let price = item["price"] as? Int, let count = item["count"] as? Int {
//                                    print("yes")
                                    let food = Food(image: nil, price: price, name: name)
                                    let item = FoodItem(food: food, count: count)
                                    invoice.append(item)
                                    
                                }
//                                print("\(document.documentID) => \(item.data())")
                            }
                            var invoiceSection = InvoiceSection(datetime: dateString, invoice: invoice)
//                            self.arrFoodItem.append(invoice)
                            sections.append(invoiceSection)
                        }
                        completion(sections, nil)
                        
                    }
                }
            }
            
        }
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
//        print(
        return section.invoice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as! ItemTableViewCell
        let section = self.sections[indexPath.section]
        let invoice = section.invoice[indexPath.row]

        cell.configureCell(invoice)
        cell.minusButton.isHidden = true
        cell.addButton.isHidden = true
        return cell
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        return section.datetime
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

