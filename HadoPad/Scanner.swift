//
//  Scanner.swift
//  HadoPad
//
//  Created by song on 2025/11/18.
//

import SwiftUI

struct Scanner: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            VStack(spacing: 20) {
                Spacer()
                Image("logo").resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 150)
                Image("huangbt")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 360)
                Spacer()
            }
            Spacer()
            Text("")
        }
        .navigationBarBackButtonHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Image("huangbg").resizable().scaledToFill())
        .ignoresSafeArea()
    }
}

#Preview {
    Scanner()
}
