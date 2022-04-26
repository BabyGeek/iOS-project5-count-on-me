//
//  Operators.swift
//  CountOnMe
//
//  Created by Paul Oggero on 22/04/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum Operator: String {
    case plus = "+"
    case minus = "-"
    case multiply = "×"
    case divide = "÷"

    var isPrioritary: Bool {
        return self == .multiply || self == .divide
    }
}
