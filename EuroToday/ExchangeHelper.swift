//
//  ExchangeHelper.swift
//  EuroToday
//
//  Created by David Wang on 2020-11-22.
//  Copyright © 2020 David Wang. All rights reserved.
//

import Foundation


enum ExchangeHelperResult: Error {
    case Success(ExchangeInfo)
    case Failure(Error)
}

class ExchangeHelper: Codable {
        
    var exchanges = ExchangeInfo()

    // https://exchangeratesapi.io
    let exchangeRatesApiUrl = "https://api.exchangeratesapi.io/latest"    
  
    private func getRates(from data: Data) -> ExchangeHelperResult {
        do {
            let decoder = JSONDecoder()
            let exchange = try decoder.decode(ExchangeInfo.self, from: data)
            return .Success(exchange)
        } catch let error {
            return .Failure(error)
        }
    }
    
    func fetchRates(completion: @escaping (ExchangeHelperResult) -> Void) {
                
        if let url = URL(string: exchangeRatesApiUrl) {
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request) { data, _, error in
                guard let exchangeData = data else {
                    if let err = error {
                        completion(.Failure(err))
                    }
                    return
                }
                completion(self.getRates(from: exchangeData))
            }
            task.resume()
        }
    }
    
    func loadRequest() {
        
        fetchRates() { result in
            switch result {
                case let .Success(exchange):
                    self.exchanges = exchange
                case let .Failure(error):
                  self.exchanges = ExchangeInfo()
                    print("Error: \(error)")
            }
        }
    }
    
    func createTimer() {
        let _ = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { timer in
            self.loadRequest()
            print("loaded")
        }
    }
    
}

