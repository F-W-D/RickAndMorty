//
//  Character.swift
//  Rick and Morty
//
//  Created by PJ Gutierrez on 9/29/20.
//

import Foundation

struct Character: Identifiable, Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let image: String
    let location: [String: String]
    
    func getLocationName() -> String {
        return location["name"] ?? ""
    }
}
