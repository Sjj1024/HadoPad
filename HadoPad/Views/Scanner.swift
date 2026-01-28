//
//  Scanner.swift
//  HadoPad
//
//  Created by song on 2026/1/27.
//

import SwiftUI

struct ScannerView: View {
    // 扫描状态
    @State var isScanning = false
    // 扫描添加用户
    @Binding var isAddUser: Bool
    // 扫描添加网址
    @State var webURl: String = ""
    // debug
    @State var debug: Bool = false

    // add user
    var addUser: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("扫描二维码以添加用户")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                Text("请将二维码置于扫描框内")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
            }
            .padding(.bottom, 100)
            .cornerRadius(10)
        }
    }

    // add web url
    var addWebURL: some View {
        VStack(spacing: 20) {
            Text("扫描二维码以访问网址")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(radius: 5)
            Text("请将二维码置于扫描框内")
                .font(.subheadline)
                .foregroundColor(.white)
                .shadow(radius: 5)
        }
        .padding(.bottom, 100)
        .cornerRadius(10)
    }

    // 扫描视图
    var body: some View {
        ZStack {
            if webURl != "" {
                WebView(webUrl: URL(string: webURl)!, debug: debug)
                    .ignoresSafeArea(.all)
            } else {
                QRCodeScannerView(isScanning: $isScanning)
                    .ignoresSafeArea(.all)
                VStack {
                    Spacer()
                    if isAddUser {
                        addUser
                    } else {
                        addWebURL
                    }
                }
            }
        }
        .statusBarHidden(true)
        .navigationBarBackButtonHidden(false)
        .onAppear {
            NotificationCenter.default.addObserver(forName: Notification.Name("QRCodeScanned"), object: nil, queue: .main) { notification in
                let code = notification.object as? String ?? ""
                print("Received scanned code in ScannerView:", code)
                if isAddUser {
                    // 处理添加用户逻辑
                    print("Adding user with code:", code)
                    // 在这里添加用户的处理逻辑
                } else {
                    // 处理网址逻辑
                    print("Setting web URL to:", code)
                    webURl = code
                }
            }
        }
    }
}
