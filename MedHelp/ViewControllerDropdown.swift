//
//  ViewControllerDropdown.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 6/12/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerDropdown: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var dropdownMenu: UIPickerView!
    
    var width : CGFloat = 250
    var height : CGFloat = 200
    
    var items = [String]()
    
    var selectedItem = "Cabeça"
    
    var controller : ViewControllerAddProblem = ViewControllerAddProblem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize = CGSizeMake(self.width, self.height);
        
        self.dropdownMenu.delegate = self
        self.dropdownMenu.dataSource = self
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.items.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.items[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(self.items[row])
        self.selectedItem = self.items[row]
    }
    
    override func viewWillDisappear(animated: Bool) {
      //  self.controller.part.titleLabel?.text = self.selectedItem
        self.controller.bodyPartLabel.text = self.selectedItem
        self.controller.selectedItem = self.selectedItem
    }
}