//
//  CharacterVM.swift
//  Rick and Morty
//
//  Created by PJ Gutierrez on 9/29/20.
//

import SwiftUI

enum CharactersPageAction {
    case previous, next, load
}

class CharactersVM: ObservableObject {
    
    private let urlString = "https://rickandmortyapi.com/api/character/"
    
    @Published var currentPage = 1
    @Published var curentCharacters: [Character] = []
    
    init() {
        self.getCharacters(action: .load)
    }
    
    private func createParamsSting(action: CharactersPageAction) -> String {

        switch action {
        case .previous:
            currentPage -= 1
            if currentPage < 1 { currentPage = 1 }
        case .next:
            currentPage += 1
            //NOTE: This is the last page *hardcoded*
            //TODO: Replace with better URL from docs
            if currentPage > 34 { currentPage = 34 }
        case .load:
            break
        }
        
        //Create Params String (load next 20 characters)
        var params = ""
        let currentCharacterNumber = (currentPage * 10) - 10
        for i in (currentCharacterNumber)..<(currentCharacterNumber+20) {
            params += "\(i),"
        }
        return params
    }
    
    func getCharacters(action: CharactersPageAction) {
    
        let params = createParamsSting(action: action)
        guard let apiURL = URL(string: "\(urlString)\(params)") else {
             return
        }
                
        let request = URLRequest(url: apiURL)
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            guard let data = data else {
                print("Data is nil")
                return
            }
            
            do {
                let results = try JSONDecoder().decode([Character].self, from: data)
                DispatchQueue.main.async {
                    //NOTE: Must be updated on Main Queue
                    self.curentCharacters = results
                }
            } catch let error {
                print("We have an error: \(error)")
            }
            
        }.resume()
    }
}
