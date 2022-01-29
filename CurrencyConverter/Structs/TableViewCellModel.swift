//
//  TableViewCellModel.swift
//  CurrencyConverter
//
//  Created by Серафима  Татченкова  on 21.01.2022.
//

import Foundation

class TableViewCellModel {
    
    init(delegate: CurrencyModelDelegate? = nil, currency: CurrencyModel) {
        self.delegate = delegate
        self.currency = currency
    }
    
    weak var delegate: CurrencyModelDelegate?
    var currency: CurrencyModel
    
    func convertToBase(amount: Double) -> Double {
        let newAmount = amount / currency.rate
        return newAmount
    }
    func convertFromBase(amount: Double) {
        let newAmount = amount * currency.rate
        delegate?.valueChanged(value: newAmount)
    }
}


