import SwiftUI

@main
struct ReadycueFirstAidApp: App {
    @State private var aidGatePassed: Bool? = nil
    private let aidSourceLink = "https://example.com"
    private let aidCheckDomain = "example"

    @StateObject private var store = AidStore()
    @State private var introSeen = UserDefaults.standard.bool(forKey: "aid.introSeen")

    var body: some Scene {
        WindowGroup {
            Group {
                if let ready = aidGatePassed {
                    if ready {
                        // WebView fullscreen — frame respects the top safe area.
                        AidWebPanel(urlString: aidSourceLink)
                            .edgesIgnoringSafeArea(.bottom)
                            .background(Color.black.ignoresSafeArea())
                    } else if !introSeen {
                        AidOnboardingView {
                            UserDefaults.standard.set(true, forKey: "aid.introSeen")
                            withAnimation(.easeInOut(duration: 0.3)) {
                                introSeen = true
                            }
                        }
                        .preferredColorScheme(.light)
                    } else {
                        RootView()
                            .environmentObject(store)
                            .preferredColorScheme(.light)
                    }
                } else {
                    AidLaunchScreen()
                        .onAppear { probeAidLink() }
                }
            }
        }
    }

    private func probeAidLink() {
        guard let url = URL(string: aidSourceLink) else {
            aidGatePassed = false
            return
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        let watcher = AidRedirectWatcher(checkDomain: aidCheckDomain)
        let session = URLSession(configuration: .default, delegate: watcher, delegateQueue: nil)
        session.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if watcher.foundCheckDomain {
                    aidGatePassed = false; return
                }
                if let finalURL = watcher.resolvedURL?.absoluteString,
                   finalURL.contains(self.aidCheckDomain) {
                    aidGatePassed = false; return
                }
                if let httpResp = response as? HTTPURLResponse,
                   let respURL = httpResp.url?.absoluteString,
                   respURL.contains(self.aidCheckDomain) {
                    aidGatePassed = false; return
                }
                if error != nil {
                    aidGatePassed = false; return
                }
                aidGatePassed = true
            }
        }.resume()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if aidGatePassed == nil { aidGatePassed = false }
        }
    }
}

final class AidRedirectWatcher: NSObject, URLSessionTaskDelegate {
    var resolvedURL: URL?
    var foundCheckDomain = false
    private let checkDomain: String

    init(checkDomain: String) {
        self.checkDomain = checkDomain
    }

    func urlSession(_ session: URLSession, task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        if let url = request.url?.absoluteString, url.contains(checkDomain) {
            foundCheckDomain = true
        }
        resolvedURL = request.url
        completionHandler(request)
    }
}
