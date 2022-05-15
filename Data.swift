//
//  Data.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/9.
//

import Foundation
import SwiftUI

struct Wave: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let point1 = CGPoint(x: rect.midX / 2, y: rect.midY)
            let point2 = CGPoint(x: rect.midX / 2 * 3, y: rect.midY)
            
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            
            path.addArc(
                center: point1,
                radius: rect.height / 4,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 0),
                clockwise: false)
            
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            
            path.addArc(
                center: point2,
                radius: rect.height / 4,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 0),
                clockwise: true)
        }
    }
    
}

let apps = [
    "1password",
    "app-store",
    "calculator",
    "camera",
    "cards",
    "clock",
    "compass",
    "duolingo",
    "facebook",
    "fantastical",
    "find-my-friends",
    "flipboard",
    "foursquare",
    "game-center",
    "garageband",
    "iBooks",
    "imovie",
    "instagram",
    "iphoto",
    "itunes-movie-trailers",
    "keynote",
    "mail",
    "maps",
    "messages",
    "music",
    "notes",
    "pages",
    "pay-with-square",
    "phone",
    "photos",
    "podcasts",
    "reminder",
    "remote",
    "safari",
    "settings",
    "spotify",
    "stocks",
    "things",
    "tweetbot",
    "twitter",
    "twitterific",
    "wallpaper",
    "wunderlist",
    "youtube"
]

