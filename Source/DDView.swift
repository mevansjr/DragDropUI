//
//  DDView.swift
//  DragDropUI
//
//  Created by Abdullah Selek on 12/11/2016.
//  Copyright © 2016 Abdullah Selek. All rights reserved.
//
//  MIT License
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

import UIKit

public protocol DDViewDelegate {
    
    func viewWasDragged(view: UIView, draggedPoint: CGPoint)
    
    func viewWasDropped(view: UIView, droppedPoint: CGPoint)
    
}

class DDView: UIView {
    
    public var delegate: DDViewDelegate?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureAction(view: self)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addGestureAction(view: self)
    }
    
    internal func addGestureAction(view: UIView) {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DDView.handlePan(_:)))
        addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc internal func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: superview!)
        let view = gestureRecognizer.view!
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        if (gestureRecognizer.state == .changed) {
            handleTouchChanged(view: view, gestureRecognizer: gestureRecognizer)
        }
        gestureRecognizer.setTranslation(CGPoint(), in: superview!)
        if (gestureRecognizer.state == .ended) {
            handleTouchEnded(view: view, gestureRecognizer: gestureRecognizer)
        }
    }
    
    internal func handleTouchChanged(view: UIView, gestureRecognizer: UIPanGestureRecognizer) {
        let point = gestureRecognizer.location(in: superview!)
        if delegate != nil {
            delegate!.viewWasDragged(view: view, draggedPoint: point)
        }
    }
    
    internal func handleTouchEnded(view: UIView, gestureRecognizer: UIPanGestureRecognizer) {
        let point = gestureRecognizer.location(in: superview!)
        if delegate != nil {
            delegate!.viewWasDropped(view: view, droppedPoint: point)
        }
    }

}