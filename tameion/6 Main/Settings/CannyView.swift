//
//  CannyView.swift
//  tameion
//
//  Created by Shola Ventures on 1/14/26.
//s
import SwiftUI
import WebKit
import Foundation
import Sentry

struct CannySSOService {
    static func fetchSSOToken(
        uid: String,
        email: String,
        name: String,
        completion: @escaping (Result<[String: String], Error>) -> Void
    ) {
        guard let cannySSOUrl = Bundle.main.object(
            forInfoDictionaryKey: "CannySSOUrl"
        ) as? String else {
            fatalError("Missing CannySSOUrl")
        }
        var components = URLComponents(string: cannySSOUrl)!

        components.queryItems = [
            URLQueryItem(name: "id", value: uid),
            URLQueryItem(name: "email", value: email),
            URLQueryItem(name: "name", value: name)
        ]

        guard let url = components.url else {
            completion(.failure(NSError()))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError()))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: String],
                   let token = json["data"] {
                    completion(.success(["token": token]))
                } else if let errorMsg = (try JSONSerialization.jsonObject(with: data) as? [String: String])?["error"] {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMsg])))
                } else {
                    completion(.failure(NSError()))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct CannyView: View {
    @State private var isLoading = true
    private let authService = FirebaseAuthService.shared

    var body: some View {
        ZStack {
            CannyWebViewContainer(isLoading: $isLoading)

            if isLoading {
                ProgressView()
                    .progressViewStyle(
                        CircularProgressViewStyle(tint: DSColor.navy_blue)
                    )
            }
        }
    }
}

struct CannyWebViewContainer: UIViewRepresentable {
    @Binding var isLoading: Bool
    private let authService = FirebaseAuthService.shared

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        loadCannyView(webView: webView)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(isLoading: $isLoading)
    }

    private func loadCannyView(webView: WKWebView) {
        guard let user = authService.currentUser,
              let email = user.email,
              let name = user.displayName
        else {
            return
        }
        
        
        
        guard let cannyBoardToken = Bundle.main.object(
            forInfoDictionaryKey: "CannyBoardToken"
        ) as? String else {
            fatalError("Missing CannyBoardToken")
        }

        CannySSOService.fetchSSOToken(
            uid: user.uid,
            email: email,
            name: name
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    guard let token = data["token"] else {
                        SentrySDK.capture(message: "No token in response")
                        self.isLoading = false
                        return
                    }

                    var components = URLComponents(string: "https://webview.canny.io")!

                    components.queryItems = [
                        URLQueryItem(
                            name: "boardToken",
                            value: cannyBoardToken
                        ),
                        URLQueryItem(
                            name: "ssoToken",
                            value: token
                        )
                    ]

                    guard let url = components.url else {
                        SentrySDK.capture(message: "Failed to build Canny URL")
                        self.isLoading = false
                        return
                    }

                    webView.load(URLRequest(url: url))

                case .failure(let error):
                    SentrySDK.capture(error: error)
                    self.isLoading = false
                }
            }
        }
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var isLoading: Bool

        init(isLoading: Binding<Bool>) {
            self._isLoading = isLoading
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            isLoading = false
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            isLoading = false
        }
    }
}
