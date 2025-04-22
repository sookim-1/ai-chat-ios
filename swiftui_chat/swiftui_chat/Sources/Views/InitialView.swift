//
//  InitialView.swift
//  swiftui_chat
//
//  Created by sookim on 4/22/25.
//

import SwiftUI

struct InitialView: View {

    @State private var showChat = false

    var body: some View {
        VStack {
            Spacer()

            Image(.chatterly)
                .resizable()
                .frame(width: 150, height: 150)

            Text("질문을 시작하세요\n무엇이든 질문해도 되요")
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.top, 20)

            Spacer()

            Button {
                showChat = true
            } label: {
                Text("채팅 시작하기")
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .sheet(isPresented: $showChat) {
            ChatView()
        }
    }
}


#Preview {
    InitialView()
}
