//
//  trailforksApp.swift
//  trailforks
//
//  Created by Michael Pace on 1/16/23.
//

import Foundation
import SwiftUI

@main
struct TrailforksApp: App {
    private let trailforksAPI = TrailforksAPI(urlSession: URLSession.shared)

    init() {
        trailforksAPI.fetchReports { result in
            print(result)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
