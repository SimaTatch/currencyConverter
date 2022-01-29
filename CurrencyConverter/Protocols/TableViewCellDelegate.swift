//
//  TableViewCellDelegate.swift
//  CurrencyConverter
//
//  Created by Серафима  Татченкова  on 21.01.2022.
//

import Foundation

protocol TableViewCellDelegate: AnyObject {
    func didChangeValue(value: Double, cell: TableViewCell)
   
}
