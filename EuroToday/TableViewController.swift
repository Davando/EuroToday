//
//  TableViewController.swift
//  EuroToday
//
//  Created by David Wang on 2020-11-22.
//  Copyright © 2020 David Wang. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}

class TableViewController: UITableViewController, UITextFieldDelegate {

    var currencies = ["CAD","HKD","ISK","PHP","DKK","HUF","CZK","AUD","RON","SEK","IDR","INR","BRL","RUB","HRK","JPY","THB","CHF","SGD","PLN","BGN","TRY","CNY","NOK","NZD","ZAR","USD","MXN","ILS","GBP","KRW","MYR"]
    
    var sortIndex = 1
    var exchangeHelper: ExchangeHelper!
    @IBOutlet weak var sortBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exchangeHelper.loadRequest()
        sortBtn.title = NSLocalizedString("sort_btn", comment: "")
        self.navigationItem.title = NSLocalizedString("Title", comment: "")
        self.tableView.reloadData()
        exchangeHelper.createTimer()
        updateTableView()
    }
    
    func updateTableView() {
        _ = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { timer in
            self.tableView.reloadData()
            print("updated")
        }
    }
    
    @IBAction func sort(_ sender: UIBarButtonItem) {
        currencies = sortIndex > 0 ? currencies.sorted() : currencies.sorted().reversed()
        sortIndex *= -1
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         // #warning Incomplete implementation, return the number of rows
        return currencies.count
     }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return CGFloat(106)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell else {
            fatalError("Expected CustomTableViewCell")
        }
        
        OperationQueue.main.addOperation() {
            let formatter = NumberFormatter()
            let code = self.currencies[indexPath.row]
            if let rates = self.exchangeHelper.exchanges.rates {
                if let price = rates[code] {
                    cell.indexLabel.text = formatter.number(with: Int(indexPath.row))
                    cell.currencyCodeLabel.text = code
                    cell.valueLabel.text = formatter.currency(with: price, code: code)
                    cell.dateLabel.text = self.exchangeHelper.exchanges.date//formatter.string(from: Date())
                    
                 } else {
                    cell.indexLabel.text = "null"
                    cell.currencyCodeLabel.text = code
                    cell.valueLabel.text = formatter.currency(with: 0, code: code)
                    cell.dateLabel.text = self.exchangeHelper.exchanges.date
                 }
             }
            
         }
        
        return cell
        
    }

}
