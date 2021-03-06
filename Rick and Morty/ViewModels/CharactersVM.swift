//
//  CharacterVM.swift
//  Rick and Morty
//
//  Created by PJ Gutierrez on 9/29/20.
//

import SwiftUI

class CharactersVM: ObservableObject {
    
    private let urlString = "https://rickandmortyapi.com/api/character/"
    
    @Published var currentPage = 1
    @Published var curentCharacters: [Character] = []
    
    init() {
        self.getMoreCharacters()
    }
    
    private func createParamsSting() -> String {
    
        //Create Params String (load next 20 characters)
        var params = ""
        let currentCharacterNumber = (currentPage * 10) - 10
        for i in (currentCharacterNumber)..<(currentCharacterNumber+20) {
            params += "\(i),"
        }
        currentPage += 1
        return params
    }
    
    func getMoreCharacters() {
    
        let params = createParamsSting()
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
                    self.curentCharacters.append(contentsOf: results)
                }
            } catch let error {
                print("We have an error: \(error)")
            }
            
        }.resume()
    }
}
