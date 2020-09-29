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
    
    @Published var currentPage = 1
    @Published var characters: [Character] = []
    
    init() {
        self.getCharacters(action: .load)
    }
    
    func getCharacters(action: CharactersPageAction) {
        
        //Adjust current page
        switch action {
        case .previous:
            currentPage -= 10
            if currentPage < 1 { currentPage = 1 }
        case .next:
            currentPage += 10
            //NOTE: This is the last page currently
            //TODO: Replace with better URL from docs
            if currentPage > 680 { currentPage = 50 }
        case .load:
            break
        }
        
        //Create Params (10 items per page)
        var params = ""
        for i in currentPage..<(currentPage+10) {
            params += "\(i),"
        }
    
        guard let apiURL = URL(string: "https://rickandmortyapi.com/api/character/\(params)") else {
             return
        }
        
        print("Making request to: \(apiURL)")
        
        //Begin Networking
        let request = URLRequest(url: apiURL)
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            //NOTE: Go to Main Thread
            //JSONDECODER
            guard let data = data else {
                print("Data is nil")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let results = try decoder.decode([Character].self, from: data)
                
                DispatchQueue.main.async {
                    self.characters = results
                }
                
            } catch let error {
                print("We have an error: \(error)")
            }
        }.resume()
    }
}
