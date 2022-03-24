import SwiftUI
import Auth0
import SafariServices
import WebKit

struct MainView: View {
    @State var profile = Profile.empty
    @State var loggedIn = false

    var body: some View {
        if loggedIn {
            VStack {
                ProfileView(profile: self.$profile)
                Button("Logout", action: self.logout)
            }
        } else {
            VStack {
                HeroView()
                Button("Login", action: self.login)
                        
            }
        }
    }
}

extension MainView {
    func login() {
        Auth0
            .webAuth()
            .logging(enabled: true)
            //.parameters(["login_hint" : "blue@user.com"])
            //.useEphemeralSession()
            .start { result in
                switch result {
                case .success(let credentials):
                    self.profile = Profile.from(credentials.idToken)
                    self.loggedIn = true
                case .failure(let error):
                    print("Failed with: \(error)")
                    
                }
            }
    }
    
    class ViewController: UIViewController, WKUIDelegate {
        
        var webView: WKWebView!
        
        override func loadView() {
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.uiDelegate = self
            view = webView
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let myURL = URL(string:"https://www.apple.com")
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }}
    

    func logout() {
        Auth0
            .webAuth()
            .clearSession { result in
                switch result {
                case .success:
                    self.loggedIn = false
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }
}
