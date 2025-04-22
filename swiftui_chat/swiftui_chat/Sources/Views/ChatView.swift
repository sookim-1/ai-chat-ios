//
//  ChatView.swift
//  swiftui_chat
//
//  Created by sookim on 4/22/25.
//

import SwiftUI
import SwiftData
import UIKit

// MARK: - 채팅 화면
struct ChatView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var messageText = ""
    @State var messages: [Message] = []
    @State private var isGenerating = false
    @State private var chatTitle = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    saveChat()
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                }

                Spacer()

                Text("Chatterly")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()
            }
            .padding()

            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(messages) { message in
                        if message.isUser {
                            HStack {
                                Spacer()

                                Text(message.content)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 16)
                                    .background(Color(red: 0.125, green: 0.114, blue: 0.404)) // #201D67
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            }
                        } else {
                            HStack(alignment: .top) {
                                Text(message.content)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 16)
                                    .background(Color.lightGray)
                                    .foregroundColor(.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                                VStack {
                                    Spacer()

                                    Button {
                                        copyToClipboard(message.content)
                                    } label: {
                                        Image(systemName: "doc.on.doc")
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()
                                }

                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }

            if isGenerating {
                HStack {
                    Rectangle()
                        .frame(width: 4, height: 16)
                        .foregroundColor(Color.yellow)

                    Text("생각하는 중 ...")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.lightGray)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(LinearGradient(
                            colors: [.orange.opacity(0.7), .orange],
                            startPoint: .top,
                            endPoint: .bottom
                        ), lineWidth: 2)
                )
                .padding(.bottom, 16)
            }

            // 입력 폼
            HStack {
                TextField("무엇이든 질문하세요", text: $messageText)
                    .padding()
                    .background(Color.lightGray)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                Button {
                    sendMessage()
                } label: {
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
        }
        .onAppear {
            if messages.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let welcomeMessage = Message(content: "안녕하세요! 무엇을 도와드릴까요?", isUser: false, timestamp: Date())
                    messages.append(welcomeMessage)
                }
            }
        }
        .toolbarVisibility(.hidden, for: .navigationBar)

    }

    private func copyToClipboard(_ text: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = text
    }

    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let userMessage = Message(content: messageText, isUser: true, timestamp: Date())
        messages.append(userMessage)

        if chatTitle.isEmpty {
            chatTitle = messageText
        }

        let currentMessage = messageText
        messageText = ""

        isGenerating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            generateResponse(to: currentMessage)
        }
    }

    private func generateResponse(to message: String) {
        Task {
            do {
                let aiMessageResponse = try await GeminiDataManager().responseCorrect(question: message)
                let aiMessage = Message(content: aiMessageResponse, isUser: false, timestamp: Date())
                messages.append(aiMessage)
                isGenerating = false
            } catch {
                print("에러 발생 \(error)")
                let aiMessage = Message(content: error.localizedDescription, isUser: false, timestamp: Date())
                messages.append(aiMessage)
                isGenerating = false
            }
        }
    }

    private func saveChat() {
        guard !messages.isEmpty else { return }

        withAnimation {
            let newItem = Item(title: messages.last?.content ?? "",
                               chatMessage: messages,
                               timestamp: Date())

            modelContext.insert(newItem)
        }
    }

}
