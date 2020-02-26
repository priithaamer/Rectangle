//
//  LeftHalfCalculation.swift
//  Rectangle, Ported from Spectacle
//
//  Created by Ryan Hanson on 6/13/19.
//  Copyright © 2019 Ryan Hanson. All rights reserved.
//

import Cocoa

class LeftRightHalfCalculation: WindowCalculation, RepeatedExecutionsCalculation {

    override func calculate(_ window: Window, lastAction: RectangleAction?, usableScreens: UsableScreens, action: WindowAction) -> WindowCalculationResult? {

        switch Defaults.subsequentExecutionMode.value {

        case .acrossMonitor:
            if action == .leftHalf {
                return calculateLeftAcrossDisplays(window, lastAction: lastAction, screen: usableScreens.currentScreen, usableScreens: usableScreens)
            } else if action == .rightHalf {
                return calculateRightAcrossDisplays(window, lastAction: lastAction, screen: usableScreens.currentScreen, usableScreens: usableScreens)
            }
            return nil
        case .resize:
            let screen = usableScreens.currentScreen
            let rectResult: RectResult = calculateRepeatedRect(window, lastAction: lastAction, visibleFrameOfScreen: screen.visibleFrame, action: action)
            return WindowCalculationResult(rect: rectResult.rect, screen: screen, resultingAction: action)
        case .none:
            let screen = usableScreens.currentScreen
            let oneHalfRect = calculateFirstRect(window, lastAction: lastAction, visibleFrameOfScreen: screen.visibleFrame, action: action)
            return WindowCalculationResult(rect: oneHalfRect.rect, screen: screen, resultingAction: action)
        }

    }

    func calculateFirstRect(_ window: Window, lastAction: RectangleAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {

//        twoThirdsRect.size.width = floor(visibleFrameOfScreen.width * 2 / 3.0) - 15
//        twoThirdsRect.size.height = visibleFrameOfScreen.height - 30
//        twoThirdsRect.origin.x = visibleFrameOfScreen.minX + visibleFrameOfScreen.width - twoThirdsRect.width - 15
//        twoThirdsRect.origin.y = visibleFrameOfScreen.minY + 15

        var oneHalfRect = visibleFrameOfScreen
        oneHalfRect.size.width = floor(visibleFrameOfScreen.width / 2.0) - 22.5
        oneHalfRect.size.height = visibleFrameOfScreen.height - 30
        if action == .rightHalf {
            oneHalfRect.origin.x += floor(visibleFrameOfScreen.width / 2.0) + 7.5
        }
        if action == .leftHalf {
            oneHalfRect.origin.x += 15
        }
        oneHalfRect.origin.y = visibleFrameOfScreen.minY + 15
        return RectResult(oneHalfRect)
    }

    func calculateSecondRect(_ window: Window, lastAction: RectangleAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {
        var twoThirdsRect = visibleFrameOfScreen
        twoThirdsRect.size.width = (floor(visibleFrameOfScreen.width / 7.0) * 3) - 22.5
        twoThirdsRect.size.height = visibleFrameOfScreen.height - 30
        if action == .rightHalf {
            twoThirdsRect.origin.x = visibleFrameOfScreen.minX + visibleFrameOfScreen.width - twoThirdsRect.size.width - 15
        }
        if action == .leftHalf {
            twoThirdsRect.origin.x += 15
        }
        twoThirdsRect.origin.y = visibleFrameOfScreen.minY + 15
        return RectResult(twoThirdsRect)
    }

    func calculateThirdRect(_ window: Window, lastAction: RectangleAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {

        var oneThirdRect = visibleFrameOfScreen
        oneThirdRect.size.width = (floor(visibleFrameOfScreen.width / 7.0) * 4) - 22.5
        oneThirdRect.size.height = visibleFrameOfScreen.height - 30
        if action == .rightHalf {
            oneThirdRect.origin.x = visibleFrameOfScreen.origin.x + visibleFrameOfScreen.width - oneThirdRect.size.width - 15
        }
        if action == .leftHalf {
            oneThirdRect.origin.x += 15
        }
        oneThirdRect.origin.y = visibleFrameOfScreen.minY + 15
        return RectResult(oneThirdRect)
    }

    func calculateLeftAcrossDisplays(_ window: Window, lastAction: RectangleAction?, screen: NSScreen, usableScreens: UsableScreens) -> WindowCalculationResult? {

        if let lastAction = lastAction, lastAction.action == .leftHalf {
            let normalizedLastRect = AccessibilityElement.normalizeCoordinatesOf(lastAction.rect, frameOfScreen: usableScreens.frameOfCurrentScreen)
            if normalizedLastRect == window.rect {
                if let prevScreen = usableScreens.adjacentScreens?.prev {
                    return calculateRightAcrossDisplays(window, lastAction: lastAction, screen: prevScreen, usableScreens: usableScreens)
                }
            }
        }

        let oneHalfRect = calculateFirstRect(window, lastAction: lastAction, visibleFrameOfScreen: screen.visibleFrame, action: .leftHalf)
        return WindowCalculationResult(rect: oneHalfRect.rect, screen: screen, resultingAction: .leftHalf)
    }


    func calculateRightAcrossDisplays(_ window: Window, lastAction: RectangleAction?, screen: NSScreen, usableScreens: UsableScreens) -> WindowCalculationResult? {

        if let lastAction = lastAction, lastAction.action == .rightHalf {
            let normalizedLastRect = AccessibilityElement.normalizeCoordinatesOf(lastAction.rect, frameOfScreen: usableScreens.frameOfCurrentScreen)
            if normalizedLastRect == window.rect {
                if let nextScreen = usableScreens.adjacentScreens?.next {
                    return calculateLeftAcrossDisplays(window, lastAction: lastAction, screen: nextScreen, usableScreens: usableScreens)
                }
            }
        }

        let oneHalfRect = calculateFirstRect(window, lastAction: lastAction, visibleFrameOfScreen: screen.visibleFrame, action: .rightHalf)
        return WindowCalculationResult(rect: oneHalfRect.rect, screen: screen, resultingAction: .rightHalf)
    }

    // Used to draw box for snapping
    override func calculateRect(_ window: Window, lastAction: RectangleAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {
        if action == .leftHalf {
            var oneHalfRect = visibleFrameOfScreen
            oneHalfRect.size.width = floor(oneHalfRect.width / 2.0)
            return RectResult(oneHalfRect)
        } else {
            var oneHalfRect = visibleFrameOfScreen
            oneHalfRect.size.width = floor(oneHalfRect.width / 2.0)
            oneHalfRect.origin.x += oneHalfRect.size.width
            return RectResult(oneHalfRect)
        }
    }
}
