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
        let minProportion = Double(minutes) / 60.0 * 10
        let secProportion = Double(seconds) / 60.0 * 10
        
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

extension Aword {
    func Aword2Color() -> [Color] {
        let totalTime2Color = StopWatch(totalSeconds: self.secondSpent).time2Color()
        
        let warnEdition = (self.edition == 0) ? 1 : self.edition
        
        let aveTime2Color = StopWatch(totalSeconds: self.secondSpent / warnEdition ).time2Color()
        
        return [aveTime2Color, totalTime2Color]
        
    }
}

struct AwordView: View {
    
    let aword: Aword
    
    var body: some View {
        
//        let totalTime2Color = StopWatch(totalSeconds: aword.secondSpent).time2Color()
//
//        let warnEdition = (aword.edition == 0) ? 1 : aword.edition
//
//        let aveTime2Color = StopWatch(totalSeconds: aword.secondSpent / warnEdition ).time2Color()
//
//        let colors = [aveTime2Color, totalTime2Color]
        let colors = aword.Aword2Color()
        
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
                AwordView(aword: Aword(text: "“sas”", secondSpent: 130, edition: 4))
            .frame(width: 200, height: 50)
    }
}
