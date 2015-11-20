//
//  CALayer+NTAnimationHelper.swift
//  NTGlossyButton
//
//  Created by Pham Nguyen Nhat Trung on 11/20/15.
//  Copyright © 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

extension CALayer {
    func pauseAnimation() {
        let pauseTime = convertTime(CACurrentMediaTime(), fromLayer: nil)
        speed = 0
        timeOffset = pauseTime
    }
    
    func resumeAnimation() {
        let pausedTime = timeOffset
        speed = 1
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause = convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        beginTime = timeSincePause
    }
}
