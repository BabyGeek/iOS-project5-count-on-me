//
//  Extensions.swift
//  CountOnMe
//
//  Created by Paul Oggero on 22/04/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
