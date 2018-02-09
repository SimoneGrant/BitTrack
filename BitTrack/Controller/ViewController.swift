//
//  ViewController.swift
//  BitTrack
//
//  Created by Simone Grant on 2/8/18.
//  Copyright © 2018 Simone Grant. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
 
    var priceTimer: Timer!
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArr = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var index = 0
    
    
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var dailyHighLabel: UILabel!
    @IBOutlet weak var dailyLowLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(true)
        priceTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(reload), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        priceTimer.invalidate()
    }
    
    func setup() {
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.selectRow(19, inComponent: 0, animated: false)
        finalURL = Network.baseURL + "USD"
        getCurrencyUpdate(url: finalURL)
    }
    
    @objc func reload() {
        getCurrencyUpdate(url: finalURL)
    }
    
    //MARK: - UIPickerView Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = Network.baseURL + currencyArray[row]
        index = row
        getCurrencyUpdate(url: finalURL)
    }
    
    //MARK: - Alamofire & SwiftyJSON Implementation
    
    func getCurrencyUpdate(url: String) {
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let json = JSON(response.result.value!)
                self.updateLabels(with: json)
            } else {
                self.currentPriceLabel.text = "No Connection"
                self.dailyHighLabel.text = "0"
                self.dailyLowLabel.text = "0"
            }
        }
    }
    
    //MARK: - Update UI
    
    func updateLabels(with json: JSON) {
        if let ask = json["ask"].double, let high = json["high"].double, let low = json["low"].double {
            currentPriceLabel.text = "\(currencySymbolArr[index])\(ask)"
            dailyHighLabel.text = "\(high)"
            dailyLowLabel.text = "\(low)"
        }
    }
    

}

