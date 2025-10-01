//
//  ContentView.swift
//  cred-vue
//
//  Created by Aman Kumar Singh on 28/09/25.
//

import SwiftUI
import RiveRuntime

struct ContentView: View {
    @State private var isSideMenuOpen = false
    @State private var showLogout = false
    @EnvironmentObject var appState: AppState
    @AppStorage("selectedTab") private var selectedTab: Tab = .user
    @AppStorage("selectedMenu") private var selectedMenu: SelectedMenu = .home
    
    private var topBarTitle: String {
        switch selectedTab {
        case .user:
            return "CREDvue"
        case .chat:
            return "Chat"
        case .transactions:
            return "Transactions"
        case .notification:
            return "Notifications"
        }
    }
    
    private var button = RiveViewModel(fileName: "menu_button", stateMachineName: "State Machine",autoPlay: false)
                                       
    var body: some View {
        ZStack {
            backgroundLayer
            sideMenuLayer
            mainContentLayer
            topBar
            tabBarLayer
            logoutOverlay
        }
    }
}

// MARK: - Subviews & Layout
private extension ContentView {

    var backgroundLayer: some View {
        Color(hex: "17203A").ignoresSafeArea()
    }

    var sideMenuLayer: some View {
        SideMenu()
            .padding(.top, 50)
            .opacity(isSideMenuOpen ? 1 : 0)
            .offset(x: isSideMenuOpen ? 0 : -300)
            .rotation3DEffect(.degrees(isSideMenuOpen ? 0 : 30),
                              axis: (x: 0, y: 1, z: 0))
            .ignoresSafeArea(.all, edges: .top)
    }

    var mainContentLayer: some View {
        Group {
            currentTabView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Background"))
        }
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .rotation3DEffect(.degrees(isSideMenuOpen ? 30 : 0),
                          axis: (x: 0, y: -1, z: 0),
                          perspective: 1)
        .offset(x: isSideMenuOpen ? 265 : 0)
        .scaleEffect(isSideMenuOpen ? 0.9 : 1)
        .ignoresSafeArea()
    }

    var topBar: some View {
        HStack(spacing: 30) {
            menuButton
            title
            Spacer()
            logoutButton
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .topLeading)
        .offset(x: isSideMenuOpen ? 216 : 0)
    }

    var tabBarLayer: some View {
        TabBar()
            .offset(y: -24)
            .background(
                LinearGradient(colors: [Color("Background").opacity(0),
                                        Color("Background")],
                               startPoint: .top,
                               endPoint: .bottom)
                    .frame(height: 150)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .allowsHitTesting(false)
            )
            .ignoresSafeArea()
            .offset(y: isSideMenuOpen ? 300 : 0)
    }

    var logoutOverlay: some View {
        Group {
            if showLogout {
                LogoutView(isPresented: $showLogout)
                    .environmentObject(appState)
                    .zIndex(1)
            }
        }
    }
}

// MARK: - Tab Content (including the missing homeView)
private extension ContentView {

    @ViewBuilder
    func currentTabView() -> some View {
        switch selectedTab {
        case .chat:
            DemoView()
        case .transactions:
            DemoView()
        case .notification:
            DemoView()
        case .user:
            homeView
        }
    }

    @ViewBuilder
    var homeView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                WalletView()
                    .environmentObject(Wallet(cards: cards))
                    .frame(height: 250)

                VStack(spacing: 20){
                    QuickActionsSection(actions: QuickAction.sampleData)
                }
                .padding(.horizontal, 10)

            }
            .padding(.top, 40)
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 100)
        }
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 120)
        }
    }
}

// MARK: - Components
private extension ContentView {

    var menuButton: some View {
        button.view()
            .frame(width: 50, height: 50)
            .mask(Circle())
            .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x: 0, y: 5)
            .onTapGesture {
                button.setInput("isOpen", value: isSideMenuOpen)
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    isSideMenuOpen.toggle()
                }
            }
    }

    var title: some View {
        Text("\(topBarTitle)")
            .customFont(.title2)
            .foregroundStyle(Color("Background 2").opacity(0.8))
            .opacity(isSideMenuOpen ? 0 : 1)
    }

    var logoutButton: some View {
        Image(systemName: "rectangle.portrait.and.arrow.right")
            .resizable()
            .scaledToFit()
            .frame(width: 25, height: 25)
            .foregroundColor(.black)
            .frame(width: 50, height: 45)
            .background(.white)
            .mask(Circle())
            .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x: 0, y: 5)
            .onTapGesture {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    showLogout = true
                }
            }
    }
}

struct DemoView: View {
    var body: some View {
        VStack {
            Text("Screen")
                .font(.largeTitle)
                .foregroundColor(.red)
        }
    }
}

struct UserView: View {
    var body: some View {
        VStack {
            Text("Profile Screen")
                .font(.largeTitle)
                .foregroundColor(.purple)
        }
    }
}

extension UIViewController {
    func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = style == .lightContent ? UIColor.black : .white
            statusBar.setValue(style == .lightContent ? UIColor.white : .black, forKey: "foregroundColor")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppState())
    }
}
