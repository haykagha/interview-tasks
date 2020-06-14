//
//  MainTableViewController.swift
//  accountingsOfStore
//
//  Created by Hayk on 6/14/20.
//  Copyright © 2020 Hayk. All rights reserved.
//

import UIKit
import Foundation

// data structure that is needed to display data in the required form
struct Accounting {
    
    var nameOfStore: String
    var date: Date
    var dateString: String
    var expencses: Int
    var sectionName: String
}


class MainTableViewController: UITableViewController {
    
    var hiddenSections: Set<Int> = [0,1,2,3,4]
    var accounting = [Accounting]()
    var monthlyАccounting = [[Accounting]]()
    var myArray =  [(key: String, value: [Accounting])]()
    var sectionArray = [String]()
    var dataArray = [[Accounting]]()
    var isUp: [Bool] = [true,true,true,true,true]
    
    
    //func gets data from plist and adds accounting array
    fileprivate func parsingData() {
        let dateFormatter = DateFormatter()
        let dateFormatterSectionName = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd HH:mm"
        dateFormatterSectionName.dateFormat = "MMMM yyyy"
        
        if let plist = PlistParser.getPlist(withName: "expenses"){
            for i in plist {
                if let name = i["name"] as? String,
                    let price = i["price"] as? Int,
                    let date = i["date"] as? Date {
                    let dateString = dateFormatter.string(from: date)
                    let sectionName = dateFormatterSectionName.string(from: date)
                    accounting.append(Accounting(nameOfStore: name, date: date, dateString: dateString, expencses: price, sectionName: sectionName))
                }
            }
        }
    }
    // func sorts the data as needs
    fileprivate func dataSorting() {
        let ready = accounting.sorted(by: { $0.date < $1.date} )
        let accountingByMonth = Dictionary(grouping: ready, by: { $0.sectionName })
        myArray = accountingByMonth.sorted(by: { $0.value[0].date > $1.value[0].date})
    }
    // func sets view's constraints
    fileprivate func setConstraints(view: UIView,trailingAnchor: NSLayoutXAxisAnchor?,trailingConst: CGFloat?, leadingAnchor: NSLayoutXAxisAnchor?,leadingConst: CGFloat?, topAnchor: NSLayoutYAxisAnchor?, bottomAnchor: NSLayoutYAxisAnchor?, widthAnchor: NSLayoutDimension?, widthMultip: CGFloat?) {
        view.translatesAutoresizingMaskIntoConstraints = false
        if let trailingAnchor = trailingAnchor,
            let trailingConst = trailingConst {
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingConst).isActive = true
        }
        if let leadingAnchor = leadingAnchor,
            let leadingConst = leadingConst {
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingConst).isActive = true
        }
        if let topAnchor = topAnchor {
            view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        }
        if let bottomAnchor = bottomAnchor {
            view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
        if let widthAnchor = widthAnchor,
            let widthMultip = widthMultip {
            view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: widthMultip).isActive = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parsingData()
        dataSorting()
        // create two arrays in order to easily define sections and rows of the tableView
        for i in myArray {
            sectionArray.append(i.key)
            dataArray.append(i.value)
        }
    }
    
    // func define numbers of sections in tableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    // func define number of rows in sections
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.hiddenSections.contains(section) {
            return 0
        }
        return dataArray[section].count
    }
    
    // func define height of rows in tableView
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    // func define height of section's header in tableView
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(100)
    }
    // func define title of section's header in tableView
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray[section]
    }
    
    
    // func define views in sections's header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // header view
        let frame = tableView.frame
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        // Define label and it's constraints, that is on left side in header view
        // It defines label and his properties
        let label = UILabel()
        label.text = sectionArray[section]
        label.font = UIFont.boldSystemFont(ofSize: 20)
        headerView.addSubview(label)
        
        // func sets label constraints
        setConstraints(view: label, trailingAnchor: nil, trailingConst: nil, leadingAnchor: headerView.leadingAnchor, leadingConst: 8, topAnchor: headerView.topAnchor, bottomAnchor: headerView.bottomAnchor, widthAnchor: headerView.widthAnchor, widthMultip: 0.4)
        
        // define section's button and it's constraints, that is on right side in header view
        
        // define sectionButton's image and it's properties
        let sectionButton = UIButton()
        if let image = UIImage(named: "down.png") {
            sectionButton.setImage(image, for: .normal)
        }
        sectionButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: headerView.frame.width / 1.25, bottom: 0, right: 0)
        headerView.addSubview(sectionButton)
        
        // func sets sectionButton constraints
        setConstraints(view: sectionButton, trailingAnchor: headerView.trailingAnchor, trailingConst: -8, leadingAnchor: nil, leadingConst: nil, topAnchor: headerView.topAnchor, bottomAnchor: headerView.bottomAnchor, widthAnchor: headerView.widthAnchor, widthMultip: 1)
        
        
        // It adds action when button is clicked
        sectionButton.tag = section
        sectionButton.addTarget(self,
                             action: #selector(self.hideSection(sender:)),
                             for: .touchUpInside)
     return headerView
}
    
    // This func is called, when button is clicked,
    @objc
    private func hideSection(sender: UIButton) {
        let section = sender.tag
        // this code changes and sets button's image down.png/up.png
        if isUp[sender.tag] {
            if let image = UIImage(named: "up.png") {
                sender.setImage(image, for: .normal)
                isUp[sender.tag] = false
            }
        } else {
            if let image = UIImage(named: "down.png") {
                sender.setImage(image, for: .normal)
                isUp[sender.tag] = true
            }
        }
        // func returns section's rows indexPath in array
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            
            for row in 0..<self.dataArray[section].count {
                indexPaths.append(IndexPath(row: row,
                                            section: section))
            }
            
            return indexPaths
        }
        
        // when section is tupped, this code delete/insert rows of that section
        if self.hiddenSections.contains(section) {
            self.hiddenSections.remove(section)
            self.tableView.insertRows(at: indexPathsForSection(),
                                      with: .fade)
        } else {
            self.hiddenSections.insert(section)
            self.tableView.deleteRows(at: indexPathsForSection(),
                                      with: .fade)
        }
    }
    
    
    // define tableView cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AccountingTableViewCell
        cell.price.text = "\(dataArray[indexPath.section][indexPath.row].expencses)"
        cell.storeName.text = dataArray[indexPath.section][indexPath.row].nameOfStore
        cell.date.text = dataArray[indexPath.section][indexPath.row].dateString
        return cell
    }
    
}
