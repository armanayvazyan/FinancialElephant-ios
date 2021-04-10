//
//  SourceModel.swift
//  FinancialElephant
//
//  Created by Davit Ghushchyan on 11/18/20.
//
import SwiftyMDLib
import Foundation

class Source: Codable {
    enum AttributeName {
        case Revenue
        case Paid_Users
        case MAU
        case Retention_Rate
        case Target_Market
    }
    
    let companies: [Company]
    let attributeComparing: AttributeComparing
    
    
    func compare(attributeName: AttributeName) -> [Double] {
        let companies = self.companies.filter({$0.isChoosed ?? true})
        
        var matrix = [[Double]]()
        
        for (i, row) in companies.enumerated() {
            matrix.append([])
            let rowAttribute = row.getAttrubiteNamed(attributeName)
            for col in companies {
                let colAttribute = col.getAttrubiteNamed(attributeName)
                matrix[i].append( rowAttribute > colAttribute ? 1.5 : rowAttribute == colAttribute ? 1 : 0.5)
            }
        }
        
        var results = [Double]()
        for row in matrix {
            let value = row.sum()
            results.append(value)
        }
        
        var p = [Double]()
        
        for (i, company) in companies.enumerated() {
            
            let attValue = company.getAttrubiteNamed(attributeName)
            
            p.append(Double(attValue) * results[i])
        }
        
        let sumP = p.sum()
        
        var pRelative = [Double]()
        
        for item in p {
            pRelative.append(item/sumP)
        }
        
        return pRelative
    }
    
    func compareDefaultAttributes() -> [Double] {
        var attributes =  [Int]()
        
        for item in attributeComparing.getActiveAttributeNames() {
            attributes.append(attributeComparing.getAttrubiteNamed(item))
        }
        
        var matrix = [[Double]]()
        
        for (i, row) in attributes.enumerated() {
            matrix.append([])
            let rowAttribute = row
            for col in attributes {
                let colAttribute = col
                matrix[i].append( rowAttribute > colAttribute ? 1.5 : rowAttribute == colAttribute ? 1 : 0.5)
            }
        }
        
        var results = [Double]()
        for row in matrix {
            let value = row.sum()
            results.append(value)
        }
        
        var p = [Double]()
        
        for (i, value) in attributes.enumerated() {
            p.append(Double(value) * results[i])
        }
        
        let sumP = p.sum()
        
        var pRelative = [Double]()
        
        for item in p {
            pRelative.append(item/sumP)
        }
        
        return pRelative
    }
    
    func solve() -> Company {
        var PnAttributesArray = [[Double]]()
        let PnBaseAttributes = compareDefaultAttributes().map({Double($0)})
        
        for attributeName in attributeComparing.getActiveAttributeNames() {
            PnAttributesArray.append( compare(attributeName: attributeName))
        }
        
        var data = [Double]()
        
        var dict = [Int:[Double]]()
        
        let count = PnAttributesArray.first?.count ?? 0
        
        for i in 0..<count {
            dict[i] = []
        }
        
        for item in PnAttributesArray {
            for (index,value) in item.enumerated() {
                dict[index]?.append(value)
            }
        }
        
        var c = dict[0]?.count ?? 0
        
        let keys = dict.keys.sorted()
        
        var newMatrix = [[Double]]()
        
        for item in keys {
            newMatrix.append(dict[item] ?? [])
        }
        
        var results = [Double]()
        for company in newMatrix {
            var sum = 0.0
            for (index, value) in company.enumerated() {
                sum += value * PnBaseAttributes[index]
            }
            results.append(sum)
            
        }
        
        let biggest = results.max() ?? 0
        let index = results.firstIndex(where: {$0 == biggest}) ?? 0
        
        let company = companies.filter({$0.isChoosed ?? true})[index]
        return company
        
    }
    
    enum CodingKeys: String, CodingKey {
        case companies
        case attributeComparing = "attribute_comparing"
    }
}

// MARK: - AttributeComparing
class AttributeComparing: Codable {
    let Revenue, Paid_Users, MAU, Retention_Rate: Int
    let Target_Market: Int
    
    var isRevenue, isPaid_Users, isMAU, isRetention_Rate, isTarget_Market: Bool?
    
    func getActiveAttributeNames() -> [Source.AttributeName] {
        var arr = [Source.AttributeName]()
        if isRevenue ?? true {
            arr.append(.Revenue)
        }
        if isPaid_Users ?? true {
            arr.append(.Paid_Users)
        }
        if isMAU ?? true {
            arr.append(.MAU)
        }
        if isRetention_Rate ?? true {
            arr.append(.Retention_Rate)
        }
        if isTarget_Market ?? true {
            arr.append(.Target_Market)
        }
        return arr
    }
    
    func getAttrubiteNamed(_ attributeName: Source.AttributeName) -> Int {
        switch attributeName {
        case .MAU: return MAU
        case .Paid_Users: return Paid_Users
        case .Revenue: return Revenue
        case .Target_Market: return Target_Market
        case .Retention_Rate: return Retention_Rate
        }
    }
    
    
}

// MARK: - Company
class Company: Codable {
    let name, imgURL: String
    let Revenue, Paid_Users, MAU, Retention_Rate: Int
    let Target_Market: Int
    var isChoosed: Bool?
    
    func getAttrubiteNamed(_ attributeName: Source.AttributeName) -> Int {
        switch attributeName {
        case .MAU: return MAU
        case .Paid_Users: return Paid_Users
        case .Revenue: return Revenue
        case .Target_Market: return Target_Market
        case .Retention_Rate: return Retention_Rate
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case imgURL = "imgUrl"
        case Revenue, Paid_Users, MAU, Retention_Rate, Target_Market
        case isChoosed
    }
}
