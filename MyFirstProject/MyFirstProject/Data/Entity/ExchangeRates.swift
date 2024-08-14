//
//  ExchangeRates.swift
//  MyFirstProject
//
//  Created by Burak on 12.08.2024.
//

import Foundation

struct ExchangeRates: Codable {
    let disclaimer: String
    let license: String
    let timestamp: Int
    let base: String
    let rates: [String: Double]
}
