//
//  Home.swift
//  HadoPad
//
//  Created by song on 2026/1/27.
//

import SwiftUI

struct Home: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    Spacer()
                    NavigationLink(destination: AddUser()) {
                        Text("添加玩家")
                            .font(.title)
                            .bold()
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .foregroundStyle(.white)
                            .background(Color.black)
                            .border(Color.cyan, width: 2)
                    }
                    .padding(.top, 35)
                    .padding(.trailing, 20)
                }
                Spacer()
                VStack(spacing: 20) {
                    Spacer()
                    Image("logo").resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 150)
                    NavigationLink(destination: ScannerView(isAddUser: .constant(false))) {
                        HStack(spacing: 40) {
                            Image("redPad")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 220)
                            Image("bluePad")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 220)
                        }
                    }
                    Spacer()
                    Spacer()
                }
                Spacer()
                Text("")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Image("pwabg").resizable().scaledToFill())
            .ignoresSafeArea()
        }
    }
}
