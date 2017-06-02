//
//  ViewController.swift
//  SimplePurchase
//
//  Created by Pavel Gnatyuk on 02/06/2017.
//  Copyright © 2017 Pavel Gnatyuk. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var purchases: PurchaseController?
    
    let items: [String] = ["Request products", "Buy product", "Start observer", "Restore purchases"]
    var actions: [() -> Void] {
        return [request, buy, start, restore]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        actions[indexPath.row]()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController {
    func request() {
        let requested = self.purchases?.requestProducts()
        print("product information request: \(requested! ? "success": "failure")")
    }
    
    func buy() {
        let purchased = self.purchases?.buy(identifier: "com.demo.in-app.purchase.SimplePurchase.two")
        print(purchased! ? "purchased" : "Failed to purchase")
    }
    
    func start() {
        self.purchases?.start()
    }
    
    func restore() {
        self.purchases?.restore()
    }
}
