//
//  Filemanager + Exchange.swift
//  EuroToday
//
//  Created by David Wang on 2020-11-28.
//  Copyright © 2020 David Wang. All rights reserved.
//

import Foundation

let kExchangeFile = "ExchangeFile"

extension FileManager {
    
    
    func getExchange() -> ExchangeHelper {
        
        if let url = urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(kExchangeFile, isDirectory: false) {
            
            if let jsondata = contents(atPath: url.path) {
                let decoder = JSONDecoder()
                do {
                    let model = try decoder.decode(ExchangeHelper.self, from: jsondata)
                    return model
                } catch { fatalError(error.localizedDescription) }
            }
        }
        
        return ExchangeHelper()
    }
    
    func saveExchange(exchange: ExchangeHelper) {
        
        if let url = urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(kExchangeFile, isDirectory: false) {
            
            if fileExists(atPath: url.path) {
                do {
                    try removeItem(at: url)
                } catch { fatalError(error.localizedDescription) }
            }
            
            if let encodedData = try? JSONEncoder().encode(exchange) {
                createFile(atPath: url.path, contents: encodedData, attributes: nil)
            } else {
                fatalError("Couldn't write data!")
            }
        }
    }

}
