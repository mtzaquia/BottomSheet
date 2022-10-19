//
//  BottomSheetTransitioningDelegate.swift
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

final class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        BottomSheetPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let bspc = dismissed.presentationController as? BottomSheetPresentationController else {
            return nil
        }
        
        return DragToDismissInteractiveTransition(panGestureRecognizer: bspc.dismissDragGestureRecognizer)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let percentDrivenInteractiveTransition = animator as? DragToDismissInteractiveTransition, percentDrivenInteractiveTransition.panGestureRecognizer.state == .began else {
            return nil
        }
        
        return percentDrivenInteractiveTransition
    }
    
    private class DragToDismissInteractiveTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
        
        private let percentageForDismissal: CGFloat = 0.4
        private let interactiveDuration = 0.4
        private let immediateDuration = 0.2
        
        private var presentedViewFrame: CGRect = .zero
        fileprivate let panGestureRecognizer: UIPanGestureRecognizer
        
        init(panGestureRecognizer: UIPanGestureRecognizer) {
            self.panGestureRecognizer = panGestureRecognizer
            super.init()
            
            panGestureRecognizer.addTarget(self, action: #selector(handlePan))
        }
        
        override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
            if let viewController = transitionContext.viewController(forKey: .from) {
                presentedViewFrame = transitionContext.initialFrame(for: viewController)
            }
            
            super.startInteractiveTransition(transitionContext)
        }
        
        @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
            switch sender.state {
                case .changed:
                    let translation: CGPoint = sender.translation(in: nil)
                    let verticalDelta: CGFloat = translation.y / presentedViewFrame.height
                    let verticalPercentage: CGFloat = max(min(verticalDelta, 1), 0)
                    update(verticalPercentage)
                case .cancelled:
                    cancel()
                case .ended:
                    percentComplete > percentageForDismissal ? finish() : cancel()
                default:
                    break
            }
        }
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            transitionContext?.isInteractive == true ? interactiveDuration : immediateDuration
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let view = transitionContext.view(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
            }
            
            UIView.animate(
                withDuration: transitionDuration(using: transitionContext),
                delay: 0,
                options: .curveLinear,
                animations: {
                    view.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
                }, completion: { _ in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            )
        }
    }
}
