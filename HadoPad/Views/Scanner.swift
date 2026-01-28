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
}
