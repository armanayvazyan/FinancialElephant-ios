//
//  SourceModel.swift
//  FinancialElephant
//
//  Created by Davit Ghushchyan on 11/18/20.
//

import Foundation

class Source: Codable {
    let companies: [Company]
    let attributeComparing: AttributeComparing
    
    enum CodingKeys: String, CodingKey {
        case companies
        case attributeComparing = "attribute_comparing"
    }
}

// MARK: - AttributeComparing
class AttributeComparing: Codable {
    let revenue, paidusers, mau, urr: Int
    let test: Int
    
}

// MARK: - Company
class Company: Codable {
    let name, imgURL: String
    let revenue, paidusers, mau, urr: Int
    let test: Int
    var isChoosed: Bool?
    
    enum CodingKeys: String, CodingKey {
        case name
        case imgURL = "imgUrl"
        case revenue, paidusers, mau, urr, test
        case isChoosed
    }
}
