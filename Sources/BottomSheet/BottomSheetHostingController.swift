//
//  BottomSheetHostingController.swift
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

/// /// **[BottomSheet]** A convenient bottom sheet presentation controller for SwiftUI views.
public final class BottomSheetHostingController<Content>: UIHostingController<Content> where Content: View {
    /// Creates a new hosting controller which gets presented as a bottom sheet.
    ///
    /// - Important: The bottom sheet will dinamically size itself based on the intrinsic SwiftUI view size.
    ///
    /// - Parameters:
    ///   - cornerRadius: The radius to be used on the top portion of the sheet.
    ///   - prefersGrabberVisible: A flag indicating if the grabber should be visible.
    ///   - allowsInteractiveDismiss: A flag indicating if dragging the bottom sheet down/tapping on the scrim should dismiss the controller.
    ///   - rootView: The `SwiftUI` view to present.
    public init(
        prefersGrabberVisible: Bool? = nil,
        cornerRadius: CGFloat? = nil,
        allowedInteractions: SupportedInteractions? = nil,
        rootView: Content
    ) {
        super.init(rootView: rootView)
        modalPresentationStyle = .custom

        if let prefersGrabberVisible = prefersGrabberVisible {
            bottomSheetPresentationController?.prefersGrabberVisible = prefersGrabberVisible
        }

        if let cornerRadius = cornerRadius {
            bottomSheetPresentationController?.cornerRadius = cornerRadius
        }

        if let allowedInteractions = allowedInteractions {
            bottomSheetPresentationController?.allowedInteractions = allowedInteractions
        }
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) { fatalError() }

    public override var modalPresentationCapturesStatusBarAppearance: Bool {
        get { true }
        set {}
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    var bottomSheetPresentationController: BottomSheetPresentationController? {
        presentationController as? BottomSheetPresentationController
    }
    
    public override var transitioningDelegate: UIViewControllerTransitioningDelegate? {
        get { BottomSheetTransitioningDelegate() }
        set {}
    }
}
