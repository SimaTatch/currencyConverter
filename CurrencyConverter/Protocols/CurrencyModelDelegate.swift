//
//  CurrencyModelDelegate.swift
//  CurrencyConverter
//
//  Created by Серафима  Татченкова  on 21.01.2022.
//

import Foundation

protocol CurrencyModelDelegate: AnyObject {
    func valueChanged(value: Double)
}
