//
//  RecentView.swift
//  swiftui_chat
//
//  Created by sookim on 4/22/25.
//

import SwiftUI
import SwiftData

// MARK: - 최근 채팅 화면
struct RecentView: View {

    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var showChat = false

    var body: some View {
        ZStack {
            if items.isEmpty == false {
                VStack(spacing: 0) {
                    Text("최근 내역")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    List {
                        ForEach(items) { item in
                            NavigationLink {
                                ChatView(messages: item.chatMessage)
                            } label: {
                                HStack {
                                    Text(item.title)
                                        .font(.headline)
                                        .lineLimit(2)

                                    Spacer()

                                    Text(item.timestamp.formatted(
                                        Date.FormatStyle()
                                            .locale(Locale(identifier: "ko_KR"))
                                            .year(.twoDigits)
                                            .month(.defaultDigits)
                                            .day(.defaultDigits)
                                            .hour(.defaultDigits(amPM: .wide))
                                            .minute(.defaultDigits)
                                    ))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(PlainListStyle())

                    chatInputBar
                }
            } else {
                InitialView()
            }
        }
        .onAppear(perform: {
            print(Bundle.main.geminiAppKey)
        })
        .sheet(isPresented: $showChat) {
            ChatView()
        }
    }

    private var chatInputBar: some View {
        HStack {
            Text("새로운 채팅 시작하기")
                .foregroundColor(.gray)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.lightGray)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            Image(systemName: "arrow.up")
                .foregroundColor(.white)
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color(.primary), Color(.subprimary)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(Circle())
        }
        .padding()
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.lightGray)
                .offset(y: -0.5),
            alignment: .top
        )
        .onTapGesture {
            showChat = true
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
}

#Preview {
    RecentView()
}
