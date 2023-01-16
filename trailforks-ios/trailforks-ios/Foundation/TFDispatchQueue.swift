//
// Created by Michael Pace on 1/16/23.
//

import Foundation

protocol TFDispatchQueue {
    func async(execute: @escaping @convention(block) () -> Void)
}

class TrailforksDispatchQueue: TFDispatchQueue {
    func async(execute: @escaping @convention(block) () -> Void) {
        DispatchQueue.main.async(execute: execute)
    }
}