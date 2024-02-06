//
//  BottomSheetModifier.swift
//
//  Copyright (c) 2021 @mtzaquia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import SwiftUI
import UIKitPresentationModifier

public extension View {
    /// **[BottomSheet]** Use this modifier to present a bottom sheet, analogous to `SwiftUI.View.sheet(...)`, but which has the needed size to wrap the contents.
    ///
    /// - Important: The content view won't inherit custom values from the presentation's environment,
    /// so those need to be manually provided again as needed.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to the presentation. The bottom sheet will automatically reset this flag when dismissed (i.e.: when tapping on the overlay).
    ///   - cornerRadius: The corner radius to be used for this bottom sheet.
    ///   - prefersGrabberVisible: A flag indicating if a grabber should be shown.
    ///   - content: The content to be displayed inside the bottom sheet.
    func bottomSheet<Content>(
        isPresented: Binding<Bool>,
        cornerRadius: CGFloat? = nil,
        prefersGrabberVisible: Bool? = nil,
        allowedInteractions: SupportedInteractions? = .all,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View where Content: View {
        modifier(
            BottomSheetModifier(
                isPresented: isPresented,
                cornerRadius: cornerRadius,
                prefersGrabberVisible: prefersGrabberVisible,
                allowedInteractions: allowedInteractions,
                content: content
            )
        )
    }
}

struct BottomSheetModifier<BottomSheet>: ViewModifier where BottomSheet: View {
    init(
        isPresented: Binding<Bool>,
        cornerRadius: CGFloat?,
        prefersGrabberVisible: Bool?,
        allowedInteractions: SupportedInteractions?,
        content: @escaping () -> BottomSheet
    ) {
        _isPresented = isPresented
        self.cornerRadius = cornerRadius
        self.prefersGrabberVisible = prefersGrabberVisible
        self.allowedInteractions = allowedInteractions
        self.content = content
    }
    
    @Binding var isPresented: Bool
    let cornerRadius: CGFloat?
    let prefersGrabberVisible: Bool?
    let allowedInteractions: SupportedInteractions?
    let content: () -> BottomSheet
    
    @State private var transitioningDelegate = BottomSheetTransitioningDelegate()
    @State private var presentingViewController: UIViewController?
    
    func body(content: Content) -> some View {
        content
            .presentation(isPresented: $isPresented, content: self.content) { content in
                BottomSheetHostingController(
                    prefersGrabberVisible: prefersGrabberVisible,
                    cornerRadius: cornerRadius,
                    allowedInteractions: allowedInteractions,
                    rootView: content
                )
            }
    }
}
