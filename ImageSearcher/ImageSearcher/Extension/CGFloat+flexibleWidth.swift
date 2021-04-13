//
//  CGFloat+flexibleWidth.swift
//  ImageSearcher
//
//  Created by 최동규 on 2021/04/13.
//

import UIKit

extension CGFloat {
    static let defaultSpacing: CGFloat = 10
    static let defaultPadding: CGFloat = 15
    static func flexibleWidth(minimum: CGFloat, maximum: CGFloat, baseWidth: CGFloat) -> CGFloat {
        var width: CGFloat = -1
        for count in (1..<15) {
            let calWidth: CGFloat = (baseWidth - (CGFloat(count - 1) * .defaultSpacing) - (2 * .defaultPadding)) / CGFloat(count)
            if (minimum...maximum).contains(calWidth) {
                width = calWidth
            } else if minimum > calWidth {
                if width == -1 {
                    width = calWidth
                }
                break
            }
        }
        return width
    }
}
