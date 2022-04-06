import SwiftUI
import SpriteKit

// MARK: Var Initilization

class timers: ObservableObject {
    @Published var isMenuOpen = false
    
    let autoTimer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()
    let updateTimer = Timer.publish(every: 0.0001, on: .main, in: .common).autoconnect()
}

class shopUpg: ObservableObject {
    //Reset level to 1 for gameplay purposes
    @Published var lev = 1
}

class cultistUpg: ObservableObject {
    @Published var lev = 1
    @Published var soulNumb:Double = 1000.0
    
    // Instead of running the code within the timer, just updates LEV which updates the value of soulNumb 
    init() {
        self.lev = 1
        self.soulNumb = 1000.0 * (Double(lev) * 5.0)
    }
    
}

class playerStats: ObservableObject {
    @Published var score:Double = 0.0
    @Published var totalScore:Double = 0.0
    @Published var cultists = 0
    @Published var souls = 0
    @Published var autoClick:Double = 0.0
    
    @Published var click:Double = 1.0
}

class clickerUPG1: ObservableObject {
    @Published var price:Double = 15
    @Published var upgrade:Double = 0.6
    @Published var lev = 1
}

class clickerUPG2: ObservableObject {
    @Published var price:Double = 5000
    @Published var upgrade:Double = 25.5
    @Published var lev = 1
}

class autoUPG1: ObservableObject {
    @Published var price:Double = 35
    @Published var upgrade:Double = 0.13
    @Published var lev = 1
}

class autoUPG2: ObservableObject {
    @Published var price:Double = 1500
    @Published var upgrade:Double = 7.5
    @Published var lev = 1
}

class autoUPG3: ObservableObject {
    @Published var price:Double = 7500
    @Published var upgrade:Double = 25.25
    @Published var lev = 1
}


// MARK: View & Layout

struct gameScreen: View {
  
    @StateObject var clickUPGOne:clickerUPG1 = clickerUPG1()
    @StateObject var clickUPGTwo:clickerUPG2 = clickerUPG2()
    
    @StateObject var autoUPGOne:autoUPG1 = autoUPG1()
    @StateObject var autoUPGTwo:autoUPG2 = autoUPG2()
    @StateObject var autoUPGThree:autoUPG3 = autoUPG3()
    
    @StateObject var shop:shopUpg = shopUpg()
    @StateObject var player:playerStats = playerStats()
    @StateObject var cults = cultistUpg()
    
    @StateObject var timer = timers()
    
    @State var showMenu = false
            
    var body: some View {
        
    NavigationView {
        ZStack {
            
            Image("backgroundLightClouds")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(alignment: .center)
            
            Text("").onReceive(timer.autoTimer) { _ in
                if (!timer.isMenuOpen) {
                    player.score += player.autoClick
                    player.totalScore += player.autoClick
                }
            }
            
            Text("").onReceive(timer.updateTimer) {
                _ in
                
                if (!timer.isMenuOpen) {
                    if (player.totalScore >= cults.soulNumb) {
                        
                        player.cultists += 1
                        cults.lev += 1
                    }
                }
            }
  
            VStack {
            
                //NavigationLink(destination: pauseMenu().navigationBarHidden(true), label: {Text("Menu")})
                 
                Button ("Menu", action: {
                    
                    timer.isMenuOpen = true
                })
                
                //Opens the menu only if isMenuOpen is true, otherwise the menu stays closed. This is to ensure the timer is not running during the pause menu.
                NavigationLink(destination: pauseMenu().navigationBarHidden(true), isActive: $timer.isMenuOpen) {EmptyView()}
                
                Spacer()
                
                Text(String(Int(player.score))).foregroundColor(Color.white)
               
                
                
                //Text(String(Int(player.totalScore)))
                    
            Spacer()
                        
            HStack {
                
                NavigationLink(destination: upgradeScreen().navigationBarHidden(true), label:{Text("UPG")})
                
                Spacer()
                
                NavigationLink(destination: cultScreen().navigationBarHidden(true), label: {Text("CULT")})
                
            }
               
                
            Spacer()
                
                Button("EMBRACE THE VOID", action: {
                    player.score += player.click
                    player.totalScore += player.click

                    
                })
            
            Spacer()
                
                NavigationLink (destination: visualScreen().navigationBarHidden(true), label: {Text("VIEW")})
                
                    }
                }
            }.environmentObject(player)
            .environmentObject(shop)
            .environmentObject(cults)
            .environmentObject(timer)
            .environmentObject(clickUPGOne)
            .environmentObject(clickUPGTwo)
            .environmentObject(autoUPGOne)
            .environmentObject(autoUPGTwo)
            .environmentObject(autoUPGThree)
        
        
        }
    }




// MARK: Upgrade Tab

struct upgradeScreen: View {
    
    @EnvironmentObject var player:playerStats
    @EnvironmentObject var shop:shopUpg
    @EnvironmentObject var cults:cultistUpg
        
    @EnvironmentObject var clickUPGOne:clickerUPG1
    @EnvironmentObject var clickUPGTwo:clickerUPG2
    
    @EnvironmentObject var autoUPGOne:autoUPG1
    @EnvironmentObject var autoUPGTwo:autoUPG2
    @EnvironmentObject var autoUPGThree:autoUPG3
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
            NavigationView {
                            
                VStack {
                    
                    Text(String(Int(player.score)))
                    
                    HStack {
                        List {
                        
                                Button(action: {
                                
                                    if (player.score >= clickUPGOne.price) {
                                        player.score -= clickUPGOne.price
                                        player.click += clickUPGOne.upgrade * Double(clickUPGOne.lev)
                                        clickUPGOne.lev += 1
                                        clickUPGOne.price *= Double(clickUPGOne.lev)
                                    }
                                }, label:{Text("Placeholder Click1: " + String(clickUPGOne.price)) + Text("\nLev: " + String(clickUPGOne.lev))})
                           
                            if (shop.lev > 1) {
                                Button (action: {
                                    
                                    if (player.score >= clickUPGTwo.price) {
                                        
                                        player.score -= clickUPGTwo.price
                                        player.click += clickUPGTwo.upgrade * Double(clickUPGOne.lev)
                                        
                                        clickUPGTwo.lev += 1
                                        clickUPGTwo.price *= Double(clickUPGOne.lev)

                                    }
                                    
                                    
                                }, label: {Text("Placeholder Click2: " + String(clickUPGTwo.price)) + Text("\nLev: " + String(clickUPGTwo.lev))

                                })
                            }

                                
                            }.listStyle(SidebarListStyle()).navigationTitle("Upgrades")
                        
                        
                        List {
                            
                            Button(action: {
                            
                                if (player.score >= autoUPGOne.price) {
                                    player.score -= autoUPGOne.price
                                    player.autoClick += autoUPGOne.upgrade * Double(autoUPGOne.lev)
                                    autoUPGOne.lev += 1
                                    autoUPGOne.price *= Double(autoUPGOne.lev)
                                }
                            }, label:{Text("Placeholder Auto: " + String(autoUPGOne.price)) + Text("\nLev: " + String(autoUPGOne.lev))})
                   
                        Button(action: {
                            if (player.score >= autoUPGTwo.price) {
                                player.score -= autoUPGTwo.price
                                player.autoClick += autoUPGTwo.upgrade * Double(autoUPGTwo.lev)
                                autoUPGTwo.lev += 1
                                autoUPGTwo.price *= Double(autoUPGTwo.lev)
                            }
                        }, label: {Text("Placeholder Auto2: " + String(autoUPGTwo.price)) + Text("\nLev: " + String(autoUPGTwo.lev))})
                            
                        if (shop.lev > 1) {
                        Button(action: {
                            if (player.score >= autoUPGThree.price) {
                                player.score -= autoUPGThree.price
                                player.autoClick += autoUPGThree.upgrade * Double(autoUPGThree.lev)
                                autoUPGThree.lev += 1
                                autoUPGThree.price *= Double(autoUPGThree.lev)
                            }
                        }, label: {Text("Placeholder Auto3: " + String(autoUPGThree.price)) + Text("\nLev: " + String(autoUPGThree.lev))})
                            }
                        }.listStyle(SidebarListStyle())
                        }
                    
                    Button(action: {self.presentationMode.wrappedValue.dismiss()}, label: {Text("Close Menu")})
                    }
                
                }

            
            }
    }


// MARK: Cultist Tab

struct cultScreen: View {

    @EnvironmentObject var player:playerStats
    @EnvironmentObject var shop:shopUpg
    @EnvironmentObject var cults:cultistUpg
        
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationView {
                            
            VStack {

                HStack {
                    Spacer()
                    Text("CULTISTS: " + String(player.cultists))
                    
                    Spacer()
                    Spacer()
                    
                    Text("SOULS: " + String(player.souls))
                    Spacer()
                }
                
                
            List {

                Button(action: {
                    
                    if (player.cultists > 0) {
                        player.cultists -= 1
                        player.souls += 1
                        shop.lev += 1
                    }
                    
                }, label:{Text("SACRIFICE")})
                
                HStack {
                    Button(action: {
                        
                    }, label: {Text("CONVERT")})
                    
                    Spacer()
                    
                    
                    //Describes the action the above button does
                    Button(action: {
                        
                    }, label: {Text("?")})
                }
                
                
                
                
            }.listStyle(SidebarListStyle()).navigationTitle("Cultists")
                                
                Button(action: {                self.presentationMode.wrappedValue.dismiss()
}, label: {Text("Close Menu")})
                }
            }
        
        
        }
    }


// MARK: Pause Menu
struct pauseMenu: View {
    
    @Environment(\.presentationMode) var presentationMode
   
    @EnvironmentObject var player:playerStats
    @EnvironmentObject var timer:timers

    //@StateObject var player:playerStats = playerStats()

    var body: some View {
        
        NavigationView {
            
            VStack {
                Spacer()

                HStack{
                    Text("TOTAL POINTS: " + String(Int(player.totalScore)))
                }
                       
                Spacer()
                
                Button(action: {
                    timer.isMenuOpen = false
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {Text("Close")})
                
                Spacer()
            }
        }
      
        
        }
    }



// MARK: Visual Story Screen
struct visualScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationView {
            ZStack{
                VStack {
                    

                    Spacer()
                    
                    SpriteView(scene: gameScene()).ignoresSafeArea().scaledToFill()

                    Spacer()
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {Text("Close")})
                    
                }
                
            }
        }

    }
}

class gameScene: SKScene {
    
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let box = SKSpriteNode(color: SKColor.red, size: CGSize(width: 15, height: 15))
        box.position = location
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 15, height: 15))
        addChild(box)
    }
    
    
}
