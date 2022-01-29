//
//  CurrencyModel.swift
//  CurrencyConverter
//
//  Created by Серафима  Татченкова  on 20.01.2022.
//

import Foundation

struct CurrencyModel {
    
    let key: String
    let rate: Double

//    ??
    func toBase() -> Double {
        1 / rate
    }
    func fromBase() -> Double {
        rate
    }
    
}


