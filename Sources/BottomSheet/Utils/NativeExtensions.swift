//
//  NativeExtensions.swift
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

import UIKit

typealias Action = () -> Void

private var actionKey: UInt8 = 0
private extension UIGestureRecognizer {
    var action: Action? {
        get { objc_getAssociatedObject(self, &actionKey) as? Action }
        set {
            objc_setAssociatedObject(
                self,
                &actionKey,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC
            )
        }
    }
}

extension UITapGestureRecognizer {
    convenience init(action: @escaping Action) {
        self.init(target: nil, action: nil)
        self.action = action
        self.addTarget(self, action: #selector(execute))
    }

    @objc private func execute() {
        action?()
    }
}
