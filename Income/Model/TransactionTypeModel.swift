//
//  TransactionTypeModel.swift
//  Income
//
//  Created by Gwinyai Nyatsoka on 30/1/2024.
//

import Foundation
import RealmSwift

enum TransactionType: String, CaseIterable, Identifiable, PersistableEnum {
    case income, expense
    var id: Self { self }
    
    var title: String {
        switch self {
        case .income:
            return "Income"
        case .expense:
            return "Expense"
        }
    }
}
