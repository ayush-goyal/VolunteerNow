//
//  BarFilterController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/8/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit
import CZPicker

class BarFilterController: UIViewController {
    
    let sortPickerDataSource: [SortType] = [.closest, .upcoming, .relevance, .popularity]
    let categoryPickerDataSource: [CategoryType] = [.children, .seniors, .animals, .education, .advocacy]
    let distancePickerDataSource: [DistanceType] = [.five, .ten, .twenty, .thirty]
    
    var sortPicker: CZPickerView! = {
        let picker = CZPickerView(headerTitle: "Sort By", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")!
        picker.needFooterView = true
        picker.checkmarkColor = UIColor.Custom.purple
        picker.confirmButtonBackgroundColor = UIColor.Custom.purple
        picker.headerBackgroundColor = UIColor.Custom.purple
        picker.headerTitleFont = UIFont.Custom.heading
        return picker
    }()
    
    var categoryPicker: CZPickerView! = {
        let picker = CZPickerView(headerTitle: "Category", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")!
        picker.needFooterView = true
        picker.allowMultipleSelection = true
        picker.checkmarkColor = UIColor.Custom.purple
        picker.confirmButtonBackgroundColor = UIColor.Custom.purple
        picker.headerBackgroundColor = UIColor.Custom.purple
        picker.headerTitleFont = UIFont.Custom.heading
        return picker
    }()
    
    var distancePicker: CZPickerView! = {
        let picker = CZPickerView(headerTitle: "Distance Within", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")!
        picker.needFooterView = true
        picker.checkmarkColor = UIColor.Custom.purple
        picker.confirmButtonBackgroundColor = UIColor.Custom.purple
        picker.headerBackgroundColor = UIColor.Custom.purple
        picker.headerTitleFont = UIFont.Custom.heading
        return picker
    }()
    
    var sortButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Sort By", for: .normal)
        button.backgroundColor = UIColor.white
        button.addShadow()
        button.setTitleColor(UIColor.Custom.purple, for: .normal)
        button.titleLabel?.font = UIFont.Custom.subTitle
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showSortPicker), for: .touchUpInside)
        return button
    }()
    
    var categoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Category", for: .normal)
        button.backgroundColor = UIColor.white
        button.addShadow()
        button.setTitleColor(UIColor.Custom.purple, for: .normal)
        button.titleLabel?.font = UIFont.Custom.subTitle
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showCategoryPicker), for: .touchUpInside)
        return button
    }()
    
    var distanceButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Distance", for: .normal)
        button.backgroundColor = UIColor.white
        button.addShadow()
        button.setTitleColor(UIColor.Custom.purple, for: .normal)
        button.titleLabel?.font = UIFont.Custom.subTitle
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showDistancePicker), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addShadowToBar()
        setupButtons()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButton))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "SofiaProRegular", size: 18)!], for: UIControlState.normal)
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        sortPicker.dataSource = self
        sortPicker.delegate = self
        distancePicker.dataSource = self
        distancePicker.delegate = self
        
        var categoryArray: [Int] = []
        for category in Event.selectedCategoryType {
            categoryArray.append(categoryPickerDataSource.index(of: category)!)
        }
        categoryPicker.setSelectedRows(categoryArray)
        
        sortPicker.setSelectedRows([sortPickerDataSource.index(of: Event.selectedSortType)!])
        distancePicker.setSelectedRows([distancePickerDataSource.index(of: Event.selectedDistanceType)!])
    }
    
    func setupButtons() {
        view.addSubview(sortButton)
        view.addSubview(categoryButton)
        view.addSubview(distanceButton)
        
        NSLayoutConstraint.activate([
            distanceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            distanceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            distanceButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            distanceButton.heightAnchor.constraint(equalToConstant: 25),
            
            sortButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            sortButton.topAnchor.constraint(equalTo: distanceButton.bottomAnchor, constant: 100),
            sortButton.heightAnchor.constraint(equalToConstant: 25),
            
            categoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            categoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            categoryButton.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 100),
            categoryButton.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    @objc func showDistancePicker() {
        distancePicker.show()
    }
    
    @objc func showSortPicker() {
        sortPicker.show()
    }
    
    @objc func showCategoryPicker() {
        categoryPicker.show()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveFilter" {
            Event.retrieveEventsFromDatabase()
        }
    }
    
    @objc func doneButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension BarFilterController: CZPickerViewDelegate, CZPickerViewDataSource {
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        if pickerView == sortPicker {
            return sortPickerDataSource.count
        } else if pickerView == categoryPicker {
            return categoryPickerDataSource.count
        } else if pickerView == distancePicker {
            return distancePickerDataSource.count
        } else { fatalError() }
    }
    
    func czpickerView(_ pickerView: CZPickerView!, attributedTitleForRow row: Int) -> NSAttributedString! {
        let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.Custom.text]
        
        if pickerView == sortPicker {
            return NSMutableAttributedString(string: sortPickerDataSource[row].rawValue.capitalized, attributes: attributes)
        } else if pickerView == categoryPicker {
            return NSMutableAttributedString(string: categoryPickerDataSource[row].rawValue.capitalized, attributes: attributes)
        } else if pickerView == distancePicker {
            return NSMutableAttributedString(string: String(distancePickerDataSource[row].rawValue)+" miles", attributes: attributes)
        } else { fatalError() }
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        if pickerView == sortPicker {
            Event.selectedSortType = sortPickerDataSource[row]
        } else if pickerView == categoryPicker {
            Event.selectedCategoryType = [categoryPickerDataSource[row]]
        } else if pickerView == distancePicker {
            Event.selectedDistanceType = distancePickerDataSource[row]
        } else { fatalError() }
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [Any]!) {
        if pickerView == categoryPicker {
            var array: [CategoryType] = []
            for row in rows {
                array.append(categoryPickerDataSource[row as! Int])
            }
            Event.selectedCategoryType = array
        } else { fatalError() }
    }
    
    
    
    
}
