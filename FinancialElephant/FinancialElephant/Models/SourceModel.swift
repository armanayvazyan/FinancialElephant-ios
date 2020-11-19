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
        case revenue
        case paidusers
        case mau
        case urr
        case test
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
    let revenue, paidusers, mau, urr: Int
    let test: Int
    
    var isRevenue, isPaidusers, isMau, isUrr, isTest: Bool?
    
    func getActiveAttributeNames() -> [Source.AttributeName] {
        var arr = [Source.AttributeName]()
        if isRevenue ?? true {
            arr.append(.revenue)
        }
        if isPaidusers ?? true {
            arr.append(.paidusers)
        }
        if isMau ?? true {
            arr.append(.mau)
        }
        if isUrr ?? true {
            arr.append(.urr)
        }
        if isTest ?? true {
            arr.append(.test)
        }
        return arr
    }
    
    func getAttrubiteNamed(_ attributeName: Source.AttributeName) -> Int {
        switch attributeName {
        case .mau: return mau
        case .paidusers: return paidusers
        case .revenue: return revenue
        case .test: return test
        case .urr: return urr
        }
    }
    
    
}

// MARK: - Company
class Company: Codable {
    let name, imgURL: String
    let revenue, paidusers, mau, urr: Int
    let test: Int
    var isChoosed: Bool?
    
    func getAttrubiteNamed(_ attributeName: Source.AttributeName) -> Int {
        switch attributeName {
        case .mau: return mau
        case .paidusers: return paidusers
        case .revenue: return revenue
        case .test: return test
        case .urr: return urr
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case imgURL = "imgUrl"
        case revenue, paidusers, mau, urr, test
        case isChoosed
    }
}
