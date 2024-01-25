//
//  SwipeButtonModifier.swift
//  iJournal SwiftData
//
//  Created by Derek Wang on 2024-01-25.
//

import Foundation
import SwiftUI

//MARK: - this is from this link: https://gist.github.com/ramzesenok/1a43a6efb999be804dad809d9c28470e


struct CustomSwipeButton {
    let image: Image?
    let title: String?
    let color: Color
    let action: () -> Void
}

struct SwipeButtonsModifier: ViewModifier {
    @State private var position: CGFloat = 0
    @State private var lastPosition: CGFloat = 0
    @State private var swipeShouldPublishNotification = true
    let buttons: [CustomSwipeButton]

    private let notificationName = Notification.Name("customSwipeDidStart")
    private let buttonWidth: CGFloat = 70
    private let animation = Animation.spring(response: 0.3, dampingFraction: 0.65, blendDuration: 0.25)

    private var count: CGFloat {
        CGFloat(self.buttons.count)
    }

    func body(content: Content) -> some View {
        ZStack {
            HStack(spacing: 0) {
                content
                    .hidden()

                ForEach(Array(zip(self.buttons, self.buttons.indices)), id: \.0.title) { button, idx in
                    let width = max(0, -self.position / self.count)

                    Button {
                        self.dismiss()
                        button.action()
                    } label: {
                        VStack {
                            if let image = button.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }

                            if let title = button.title {
                                Text(title)
                                    .fixedSize()
                                    .font(.footnote)
                            }
                        }
                        .foregroundColor(.white)
                        .frame(width: width)
                        .frame(maxHeight: .infinity)
                        .background(button.color)
                    }
                    .cornerRadius(30)
                }
            }

            content
                .offset(x: self.position)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if self.swipeShouldPublishNotification {
                                NotificationCenter.default.post(Notification(name: self.notificationName))

                                self.swipeShouldPublishNotification = false
                            }

                            if value.translation.width < 0 || self.lastPosition < 0 {
                                self.position = self.lastPosition + value.translation.width
                            }
                            
                            print(value.translation.width)
                        }
                        .onEnded { value in
                            self.swipeShouldPublishNotification = true
                            
                            print("ENDED")
                            
                            // check if translation is enough to trigger swipe to delete
                            if value.translation.width < -260 {
                                if let actionButton = buttons.last {
                                    actionButton.action()
                                }
                                self.dismiss()
                            }
                            
                            if value.translation.width < 0 && abs(value.translation.width + self.lastPosition) > 20 * self.count {
                                let fixedWidth = -self.buttonWidth * self.count

                                withAnimation(self.animation) {
                                    self.position = fixedWidth
                                    self.lastPosition = fixedWidth
                                }
                            } else {
                                self.dismiss()
                            }
                        }
                )
                .onReceive(NotificationCenter.default.publisher(for: self.notificationName)) { _ in
                    self.dismiss()
                }
        }
    }

    private func dismiss() {
        withAnimation(self.animation) {
            self.position = 0
            self.lastPosition = 0
        }
    }
}

extension View {
    func swipeButtons(_ buttons: [CustomSwipeButton]) -> some View {
        self.modifier(SwipeButtonsModifier(buttons: buttons))
    }
}
