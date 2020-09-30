//
//  ContentView.swift
//  Rick and Morty
//
//  Created by PJ Gutierrez on 9/29/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State private var selectedCharacter: Character?
    @State private var showingAlert = false
    @ObservedObject var charactersVM = CharactersVM()

    var body: some View {
        NavigationView {
            List {
                ForEach(charactersVM.curentCharacters) { character in
                    HStack {
                        
                        UrlImageView(urlString: character.image)
                            .frame(width: 40)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                        
                        Button(action: {
                            self.selectedCharacter = character
                            self.showingAlert = true
                        }) {
                            Text(character.name).fontWeight(.bold)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Status: " + character.status).fontWeight(.light).font(.system(size: 12))
                            Text("Species: " + character.species).fontWeight(.light).font(.system(size: 12))
                        }
                    }
                    .padding(10.0)
                }
                Rectangle()
                    .foregroundColor(Color.white)
                    .onAppear {
                        getMoreCharacters()
                    }
            }//List
            .environment(\.defaultMinListRowHeight, 50)
            .navigationBarTitle("Rick & Morty Characters\n")
        }//Nav
        .alert(isPresented: $showingAlert) {
            
            let name = selectedCharacter?.name ?? ""
            let locationName = selectedCharacter?.getLocationName() ?? ""
            
            return Alert(title: Text(name),
                  message: Text("This character is located on \(locationName)"),
                  dismissButton: .default(Text("Got it!")))
        }
    }

    private func getMoreCharacters() {
        withAnimation {
            charactersVM.getMoreCharacters()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
