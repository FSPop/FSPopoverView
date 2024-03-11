//
//  _FSPopoverPassthroughContainerView.swift
//  FSPopoverView
//
//  Created by FSPopoverView on 2024/3/11.
//
        

import UIKit

final class _FSPopoverPassthroughContainerView: UIView {
    
    private let passthroughViews: [UIView]?
    
    init(passthroughViews: [UIView]?) {
        self.passthroughViews = passthroughViews
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let passthroughViews = passthroughViews else {
            return super.point(inside: point, with: event)
        }
        let view = passthroughViews.first(where: {
            let p = self.convert(point, to: $0)
            return $0.point(inside: p, with: event)
        })
        if let _ = view {
            return false
        }
        return super.point(inside: point, with: event)
    }
}
