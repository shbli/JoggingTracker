//
//  ArrayExtension.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-08.
//  Copyright © 2018 Shbli. All rights reserved.
//

extension Array {
    //insert at the proper position, making sure the array stays in order
    func insertionIndexOf(elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if isOrderedBefore(self[mid], elem) {
                lo = mid + 1
            } else if isOrderedBefore(elem, self[mid]) {
                hi = mid - 1
            } else {
                return mid // found at position mid
            }
        }
        return lo // not found, would be inserted at position lo
    }
}
