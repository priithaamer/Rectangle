//
//  RightTwoThirdsCalculation.swift
//  Rectangle
//
//  Created by Ryan Hanson on 7/26/19.
//  Copyright © 2019 Ryan Hanson. All rights reserved.
//

import Foundation

class LastTwoThirdsCalculation: WindowCalculation {
    
    override func calculateRect(_ window: Window, lastAction: RectangleAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {
        
        return isLandscape(visibleFrameOfScreen)
            ? RectResult(rightTwoThirds(visibleFrameOfScreen), subAction: .rightTwoThirds)
            : RectResult(bottomTwoThirds(visibleFrameOfScreen), subAction: .bottomTwoThirds)
    }
    
    private func rightTwoThirds(_ visibleFrameOfScreen: CGRect) -> CGRect {
        
        var twoThirdsRect = visibleFrameOfScreen
        twoThirdsRect.size.width = floor(visibleFrameOfScreen.width * 2 / 3.0) - 15
        twoThirdsRect.size.height = visibleFrameOfScreen.height - 30
        twoThirdsRect.origin.x = visibleFrameOfScreen.minX + visibleFrameOfScreen.width - twoThirdsRect.width - 15
        twoThirdsRect.origin.y = visibleFrameOfScreen.minY + 15
        return twoThirdsRect
    }
    
    private func bottomTwoThirds(_ visibleFrameOfScreen: CGRect) -> CGRect {
        
        var twoThirdsRect = visibleFrameOfScreen
        twoThirdsRect.size.height = floor(visibleFrameOfScreen.height * 2 / 3.0)
        return twoThirdsRect
    }
}

