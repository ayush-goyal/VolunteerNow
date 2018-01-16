//
//  BarFilterController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/8/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

class BarFilterController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var sortPicker: UIPickerView!
    
    let sortPickerDataSource: [SortType] = [.closest, .upcoming, .relevance, .popularity]
    let categoryPickerDataSource: [CategoryType] = [.all, .children, .seniors, .animals, .education, .advocacy]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addShadowToBar()
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        sortPicker.dataSource = self
        sortPicker.delegate = self
        
        categoryPicker.selectRow(categoryPickerDataSource.index(of: Event.selectedCategoryType)!, inComponent: 0, animated: false)
        sortPicker.selectRow(sortPickerDataSource.index(of: Event.selectedSortType)!, inComponent: 0, animated: false)
        
    }
    
    //MARK: - Picker Functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker {
            return categoryPickerDataSource.count
        } else if pickerView == sortPicker {
            return sortPickerDataSource.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPicker {
            return categoryPickerDataSource[row].rawValue.capitalized
        } else if pickerView == sortPicker {
            return sortPickerDataSource[row].rawValue.capitalized
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveFilter" {
            Event.selectedCategoryType = categoryPickerDataSource[categoryPicker.selectedRow(inComponent: 0)]
            Event.selectedSortType = sortPickerDataSource[sortPicker.selectedRow(inComponent: 0)]
            Event.updateSelectedEventsList()
        }
    }
    
}
