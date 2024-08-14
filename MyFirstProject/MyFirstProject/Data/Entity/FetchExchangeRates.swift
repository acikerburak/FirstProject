//
//  FetchExchangeRates.swift
//  MyFirstProject
//
//  Created by Burak on 12.08.2024.
//

import Foundation

func fetchExchangeRates(completion: @escaping (Double?, Double?, Double?, Double?) -> Void) {
    let urlString = "https://openexchangerates.org/api/latest.json?app_id=089cbb5d78994921b0da7f7bdd924a81"
    guard let url = URL(string: urlString) else { return }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error fetching data: \(error)")
            completion(nil, nil, nil, nil)
            return
        }
        
        guard let data = data else {
            print("No data returned")
            completion(nil, nil, nil, nil)
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let exchangeRates = try decoder.decode(ExchangeRates.self, from: data)
            
            let usdRate = exchangeRates.rates["USD"]
            let eurRate = exchangeRates.rates["EUR"]
            let tryRate = exchangeRates.rates["TRY"]
            let xauRate = exchangeRates.rates["XAU"]
            
            completion(usdRate, eurRate, tryRate, xauRate)
            
        } catch {
            print("Error parsing JSON: \(error)")
            completion(nil, nil, nil, nil)
        }
    }
    
    task.resume()
}
