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
        
        let secProportion = Double(totalSeconds) / 60.0 * 0.3
        let minProportion = Double(totalSeconds) / 3600.0 * 0.8 + 0.2
        let hrsProportion = Double(totalSeconds) / 43200.0 * 0.5 + 0.5
        
        if self.hours != 0 {
            return Color("hrs").opacity(hrsProportion)
        } else if self.minutes != 0 {
            return Color("min").opacity(minProportion)
        } else if self.seconds != 0 {
            return Color("sec").opacity(secProportion)
        } else {
            return       Color("mon").opacity(0.1)
        }
        
    }
    
}

extension Aword {
    func Aword2Color() -> [Color] {
        let totalTime2Color = StopWatch(totalSeconds: self.secondSpent).time2Color()
        
        let warnEdition = (self.edition == 0) ? 1 : self.edition
        
        let aveTime2Color = totalTime2Color.opacity( 1.0 / Double(warnEdition))
        
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
        
        ZStack{
            
            RoundedRectangle(cornerRadius: 0, style: .continuous)
                    .fill(
                        LinearGradient(gradient: Gradient(colors: colors),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                        
                    )
            
            HStack(alignment: .top) {
                Text(aword.text)
                Spacer()
                VStack {
                    Spacer()
                    Text("total sec:" + aword.secondSpent.description)
                        .underline()
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                    Text("edition:" + aword.edition.description)
                        .underline()
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                }
                .opacity(0.4)
                .frame(width: 30, height: 20, alignment: .trailing)
                
            }
            .padding(5)
            
        }

        
    }
    
}


struct AwordView_Previews: PreviewProvider {
    static var previews: some View {
                AwordView(aword: Aword(text: "saakdhfakldhsakldhsalkdhsaldhkjahdsalkdhjahjdsadkhalksdhjjkjasjkasjkasjaksjasjkasjkajsdkjjkkjjjjj", secondSpent: 130, edition: 4))
            .frame(width: 200, height: 50)
    }
}
