import SwiftUI

@main struct MyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            Live2DView().ignoresSafeArea()
                .overlay {
                    Text("Swift UI Overlay")
                        .font(.largeTitle)
                        .foregroundStyle(Color.red)
                }
        }
    }
}

struct Live2DView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> ViewController {
        let vc = ViewController()
        AppDelegate.sharedInstance().viewController = vc
        return vc
    }

    func updateUIViewController(
        _ uiViewController: ViewController,
        context: Context
    ) {}
}
