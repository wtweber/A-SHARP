//
//  Functions.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import Foundation
import UIKit

func imageExists(named _name: String) -> Bool {
    if let _ = UIImage.init(named: _name) {
        return true
    }
    return false
}
