//
//  Scanner.swift
//  HadoPad
//
//  Created by song on 2025/11/18.
//

import SwiftUI

struct AddUser: View {
    
    // back button
    @Environment(\.presentationMode) var presentationMode

    // back button end
    var body: some View {
        NavigationStack{
            VStack(alignment: .center, spacing: 20) {
                HStack(alignment: .center) {
                    Text("< 返回")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .onTapGesture {
                            print("Back button tapped")
                            presentationMode.wrappedValue.dismiss()
                        }
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.top, 20)
                VStack(spacing: 20) {
                    Spacer()
                    Image("logo").resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 150)
                    NavigationLink(destination: ScannerView(isAddUser: .constant(true))) {
                        Image("huangbt")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 360)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Image("huangbg").resizable().scaledToFill())
        .ignoresSafeArea()
    }
}

#Preview {
    AddUser()
}
