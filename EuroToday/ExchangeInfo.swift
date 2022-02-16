//
//  ExchangeInfo.swift
//  EuroToday
//
//  Created by David Wang on 2020-11-22.
//  Copyright © 2020 David Wang. All rights reserved.
//

import Foundation

struct ExchangeInfo: Equatable, Codable {
      
    var base: String?
    let date = getDate()
    var rates: [String:Double]?
}

func getDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a zzz"
    return formatter.string(from: Date())
}
