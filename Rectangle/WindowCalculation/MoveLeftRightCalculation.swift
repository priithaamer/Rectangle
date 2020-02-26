//
//  MoveLeftRightCalculation.swift
//  Rectangle
//
//  Created by Ryan Hanson on 7/26/19.
//  Copyright © 2019 Ryan Hanson. All rights reserved.
//

import Cocoa

class MoveLeftRightCalculation: WindowCalculation {
    
    override func calculate(_ window: Window, lastAction: RectangleAction?, usableScreens: UsableScreens, action: WindowAction) -> WindowCalculationResult? {
        
        if action == .moveLeft {
            return calculateLeft(window, lastAction: lastAction, screen: usableScreens.currentScreen, usableScreens: usableScreens)
        } else if action == .moveRight {
            return calculateRight(window, lastAction: lastAction, screen: usableScreens.currentScreen, usableScreens: usableScreens)
        } else if action == .moveLeftUp {
            return calculateLeftUp(window, lastAction: lastAction, screen: usableScreens.currentScreen, usableScreens: usableScreens)
        } else if action == .moveLeftDown {
            return calculateLeftDown(window, lastAction: lastAction, screen: usableScreens.currentScreen, usableScreens: usableScreens)
        } else if action == .moveRight {
            return calculateRight(window, lastAction: lastAction, screen: usableScreens.currentScreen, usableScreens: usableScreens)
        } else if action == .moveRightUp {
            return calculateRightUp(window, lastAction: lastAction, screen: usableScreens.currentScreen, usableScreens: usableScreens)
        } else if action == .moveRightDown {
            return calculateRightDown(window, lastAction: lastAction, screen: usableScreens.currentScreen, usableScreens: usableScreens)
        }
        
        return nil
    }
    
    func calculateLeft(_ window: Window, lastAction: RectangleAction?, screen: NSScreen, usableScreens: UsableScreens) -> WindowCalculationResult? {
        
        if Defaults.subsequentExecutionMode.value == .acrossMonitor {
            
            if let lastAction = lastAction, lastAction.action == .moveLeft {
                let normalizedLastRect = AccessibilityElement.normalizeCoordinatesOf(lastAction.rect, frameOfScreen: usableScreens.frameOfCurrentScreen)
                if normalizedLastRect == window.rect {
                    if let prevScreen = usableScreens.adjacentScreens?.prev {
                        return calculateRight(window, lastAction: lastAction, screen: prevScreen, usableScreens: usableScreens)
                    }
                }
            }
        }

        let visibleFrameOfScreen = screen.visibleFrame
        
        var calculatedWindowRect = window.rect
        calculatedWindowRect.origin.x = visibleFrameOfScreen.minX + 15
        
        if window.rect.height >= visibleFrameOfScreen.height {
            calculatedWindowRect.size.height = visibleFrameOfScreen.height
            calculatedWindowRect.origin.y = visibleFrameOfScreen.minY
        } else if Defaults.centeredDirectionalMove.enabled != false {
            calculatedWindowRect.origin.y = round((visibleFrameOfScreen.height - window.rect.height) / 2.0) + visibleFrameOfScreen.minY
        }
        return WindowCalculationResult(rect: calculatedWindowRect, screen: screen, resultingAction: .moveLeft)
        
    }
    
    func calculateLeftUp(_ window: Window, lastAction: RectangleAction?, screen: NSScreen, usableScreens: UsableScreens) -> WindowCalculationResult? {
        let visibleFrameOfScreen = screen.visibleFrame
        
        var calculatedWindowRect = window.rect
        calculatedWindowRect.origin.x = visibleFrameOfScreen.minX + 15
        calculatedWindowRect.origin.y = visibleFrameOfScreen.maxY - window.rect.height - 15
        
        return WindowCalculationResult(rect: calculatedWindowRect, screen: screen, resultingAction: .moveLeft)
        
    }
    
    func calculateLeftDown(_ window: Window, lastAction: RectangleAction?, screen: NSScreen, usableScreens: UsableScreens) -> WindowCalculationResult? {
        let visibleFrameOfScreen = screen.visibleFrame
        
        var calculatedWindowRect = window.rect
        calculatedWindowRect.origin.x = visibleFrameOfScreen.minX + 15
        calculatedWindowRect.origin.y = visibleFrameOfScreen.minY + 15
        
        return WindowCalculationResult(rect: calculatedWindowRect, screen: screen, resultingAction: .moveLeft)
        
    }
    
    
    func calculateRight(_ window: Window, lastAction: RectangleAction?, screen: NSScreen, usableScreens: UsableScreens) -> WindowCalculationResult? {
        
        if Defaults.subsequentExecutionMode.value == .acrossMonitor {
            
            if let lastAction = lastAction, lastAction.action == .moveRight {
                let normalizedLastRect = AccessibilityElement.normalizeCoordinatesOf(lastAction.rect, frameOfScreen: usableScreens.frameOfCurrentScreen)
                if normalizedLastRect == window.rect {
                    if let nextScreen = usableScreens.adjacentScreens?.next {
                        return calculateLeft(window, lastAction: lastAction, screen: nextScreen, usableScreens: usableScreens)
                    }
                }
            }
        }
        
        let visibleFrameOfScreen = screen.visibleFrame
        
        var calculatedWindowRect = window.rect
        calculatedWindowRect.origin.x = visibleFrameOfScreen.maxX - window.rect.width - 15
        
        if window.rect.height >= visibleFrameOfScreen.height {
            calculatedWindowRect.size.height = visibleFrameOfScreen.height
            calculatedWindowRect.origin.y = visibleFrameOfScreen.minY
        } else if Defaults.centeredDirectionalMove.enabled != false {
            calculatedWindowRect.origin.y = round((visibleFrameOfScreen.height - window.rect.height) / 2.0) + visibleFrameOfScreen.minY
        }
        return WindowCalculationResult(rect: calculatedWindowRect, screen: screen, resultingAction: .moveRight)

    }
    
    func calculateRightUp(_ window: Window, lastAction: RectangleAction?, screen: NSScreen, usableScreens: UsableScreens) -> WindowCalculationResult? {
        let visibleFrameOfScreen = screen.visibleFrame
        
        var calculatedWindowRect = window.rect
        calculatedWindowRect.origin.x = visibleFrameOfScreen.maxX - window.rect.width - 15
        calculatedWindowRect.origin.y = visibleFrameOfScreen.maxY - window.rect.height - 15
        
        return WindowCalculationResult(rect: calculatedWindowRect, screen: screen, resultingAction: .moveLeft)

    }
    
    func calculateRightDown(_ window: Window, lastAction: RectangleAction?, screen: NSScreen, usableScreens: UsableScreens) -> WindowCalculationResult? {
        let visibleFrameOfScreen = screen.visibleFrame
        
        var calculatedWindowRect = window.rect
        calculatedWindowRect.origin.x = visibleFrameOfScreen.maxX - window.rect.width - 15
        calculatedWindowRect.origin.y = visibleFrameOfScreen.minY + 15
        
        return WindowCalculationResult(rect: calculatedWindowRect, screen: screen, resultingAction: .moveLeft)
    }
    
    // unused
    override func calculateRect(_ window: Window, lastAction: RectangleAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {
        return RectResult(CGRect.null)
    }
    
}

