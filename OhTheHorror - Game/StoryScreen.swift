import SwiftUI

struct mainMenu: View {
    
    @State var startGame = false
    
    //Loads in saved data when starting the app, is set to save for testing purposes
    
    let loadedData = dataStorage()
        
    var body: some View {
        
        NavigationView {
                    ZStack {
                        
                    VStack{
                        Spacer()
                        
                        Text("Game Title")
                        
                        
                        Spacer()
                        Spacer()
                        
                        
                        NavigationLink(destination: settingsMenu().navigationBarHidden(true), label: {Text("Help")})
                        
                        Spacer()
                        
                        Button(action: {
                            
                            self.loadedData.loadData()
                            
                            startGame = true
                            //something something initialize saved data
                            
                        }, label: {Text("PlayGame")})
                        
                        
                        NavigationLink(destination: gameScreen().navigationBarHidden(true), isActive: $startGame) {EmptyView()}

                        Spacer()
                        }
                }
        }
    }
}

struct settingsMenu: View {
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
             
        NavigationView {
            ZStack {
                VStack {
                
                Spacer()

                NavigationLink (destination: aboutUs().navigationBarHidden(true), label: {Text("About")}).navigationBarTitle("").navigationBarHidden(true)
                
                Spacer()
                    
                    Button(action: {self.presentationMode.wrappedValue.dismiss()
                        
                    }, label: {Text("Close")})                    

                Spacer()
                Spacer()
                }
            }
        
        }
        
    }
}

struct aboutUs: View {
    var body: some View {

        NavigationView {
            
            
            
        }
        
    }
}
