//
//  Utils.swift
//  EuroToday
//
//  Created by David Wang on 2020-11-22.
//  Copyright © 2020 David Wang. All rights reserved.
//

import Foundation

enum URLError: Error {
    case BadURL
    case NotImplementedYet
}

let session: URLSession = {
    return URLSession(configuration: URLSessionConfiguration.default)
}()

extension NumberFormatter {
    
    func currency(with price: Double, code: String) -> String {
        usesGroupingSeparator = true
        numberStyle = .currency
        currencyCode = code
        return string(from: NSNumber(value: price)) ?? ""
    }
    
    func number(with index: Int) -> String {
        return string(from: NSNumber(value: index)) ?? ""
    }
}
