//
//  AwordView.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/23.
//

import SwiftUI

struct StopWatch {
    
    var totalSeconds: Int
    var hours: Int {
        return totalSeconds / 3600
    }
    
    var minutes: Int {
        return (totalSeconds % 3600) / 60
    }
    
    var seconds: Int {
        return totalSeconds % 60
    }
    
    func time2Color() -> Color {
        
        let dayProportion = Double(hours) / 24.0
        let minProportion = Double(minutes) / 60.0
        let secProportion = Double(seconds) / 60.0
        
        if self.hours != 0 {
            return Color("hrs").opacity(dayProportion)
        } else if self.minutes != 0 {
            return Color("min").opacity(minProportion)
        } else if self.seconds != 0 {
            return Color("sec").opacity(secProportion)
        } else {
            return       Color("mon")
        }
        
    }
    
}


// sec2date
extension AwordView {
    
    func sec2date() -> String {
        
        let sec = self.aword.secondSpent
        
        return StopWatch(totalSeconds: sec).seconds.description
    }
    
    
    func convertSecondsToHrMinuteSec(seconds:Int) -> String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full
        
        let formattedString = formatter.string(from:TimeInterval(seconds))!
        return formattedString
        
    }
    
}

struct AwordView: View {
    
    let aword: Aword
    //    let colors: [Color] = [Color("sec"),Color("min"),Color("hrs").opacity(0.2)].map {$0.opacity(1)}
    @State private var slider:Double = 0.1
    
    var body: some View {
        
        let totalTime2Color = StopWatch(totalSeconds: aword.secondSpent).time2Color()
        
        let warnEdition = aword.edition == 0 ? 1 : aword.edition
        
        let aveTime2Color = StopWatch(totalSeconds: aword.secondSpent / warnEdition ).time2Color()

                let colors = [aveTime2Color, totalTime2Color]
        
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(
                    LinearGradient(gradient: Gradient(colors: colors),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                    
                )
                .background(.ultraThinMaterial)
        }
        
    }


struct AwordView_Previews: PreviewProvider {
    static var previews: some View {
        AwordView(aword: Aword(text: "如青烟一般,这一口气直接给我干的没脾气了", secondSpent: 20, edition: 5))
//        AwordView(aword: Aword())
    }
}
