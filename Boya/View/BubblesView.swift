//
//  BubblesView.swift
//  Boya
//
//  Created by Andy Jado on 2022/6/2.
//
import SwiftUI
import Combine

struct BubblesView: View {
    
    var tap2Action: () -> Void = {}
    
    @EnvironmentObject var viewModel: EditViewModel
    
    @State var threadsVec:[(String , [Aword])] = []
    
    @State private var slider:Double = 0.4
    
    private static let size: CGFloat = sizeManager.GuaRadius
    private static let spacingBetweenColumns: CGFloat = 8
    private static let spacingBetweenRows: CGFloat = 0
    private static let totalColumns: Int = 7
    
    let gridItems = Array(
        repeating: GridItem(
            .fixed(size),
            spacing: spacingBetweenColumns,
            alignment: .center
        ),
        count: totalColumns
    )
    
    func getThreads() {
        for (k , thread) in viewModel.threadsCache {
            
            threadsVec.append((k , thread))
            
        }
        
    }
    
    var body: some View {
        
        
        VStack {
            GeometryReader { geo in
                let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
                
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    
                    ZStack {
                        //            Axes()
                        //                .edgesIgnoringSafeArea([.all])
                        LazyVGrid(
                            columns: gridItems,
                            alignment: .center,
                            spacing: Self.spacingBetweenRows
                        ) {
                            ForEach(0..<threadsVec.count,id: \.self) { value in
                                GeometryReader { proxy in
                                    
                                    let currentPoint = getCurrentPoint(proxy: proxy, value: value)
                                    
                                    let scale = scale(currentPoint: currentPoint, center: center)
 
                                    ThreadVIew(thread: threadsVec[value].1)
                                        .shadow(color: .primary, radius: 2, y: 1)
                                        .overlay {
                                            Text(threadsVec[value].0)
                                                .foregroundColor(.secondary)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.4)
                                                .frame(width: 30)
                                        }
                                        .scaleEffect(
                                            scale
                                        )
                                        .offset(
                                            x: offsetX(value),
                                            y: 40 * scale
                                        )
                                        .onTapGesture(count:2) {
                                            viewModel.cacheBack(for: threadsVec[value].0)
                                            threadsVec.remove(at: value)
                                            tap2Action()
                                        }
                                }
                                .frame(
                                    height: Self.size
                                )
                                
                            }
                        }
                        .padding(.horizontal,80)
                        .padding(.vertical,300)
                        
                    }
                }
            }
        }
        .task {
            getThreads()
        }
    }
    
    
    func offsetX(_ value: Int) -> CGFloat {
        let rowNumber = value / gridItems.count
        
        if rowNumber % 2 == 0 {
            return Self.size/2 + Self.spacingBetweenColumns/2
        }
        
        return 0
    }
    
    
    
    func getCurrentPoint(proxy: GeometryProxy, value: Int) -> CGPoint {
        
        let rowNumber = value / gridItems.count
        
        // We need to consider the offset for even rows!
        let x = (rowNumber % 2 == 0)
        ? proxy.frame(in: .global).midX + proxy.size.width/2
        : proxy.frame(in: .global).midX
        
        let y = proxy.frame(in: .global).midY
        //        let maxDistanceToCenter = getDistanceFromEdgeToCenter(x: x, y: y, center: center)
        return CGPoint(x: x, y: y)
        
    }
    
    func willScale(currentPoint: CGPoint, center: CGPoint, thresholdScale: CGFloat) -> Bool {
        // therefore it's a circle visually
        let maxDistanceToCenter = center.x
        
        let distanceFromCurrentPointToCenter = distanceBetweenPoints(p1: center, p2: currentPoint)
        
        let threshold = maxDistanceToCenter * (1 - thresholdScale)
        
        if distanceFromCurrentPointToCenter > threshold  {
            return true
        } else {
            return false
        }
        
    }
    
    func scale(currentPoint: CGPoint, center: CGPoint) -> CGFloat  {
        let maxDistanceToCenter = center.x
        let distanceFromCurrentPointToCenter = distanceBetweenPoints(p1: center, p2: currentPoint)
        
        // This creates a threshold for not just the pure center could get
        // the max scaleValue.
        
        let distanceDelta0 =  maxDistanceToCenter - distanceFromCurrentPointToCenter
        
        let distanceDelta = min(
            //            abs(distanceFromCurrentPointToCenter - maxDistanceToCenter),
            distanceDelta0 > 0 ? distanceDelta0 : 0,
            maxDistanceToCenter * 0.33
        )
        // Helps to get closer to scale 1.0 after the threshold.
        let scalingFactor:CGFloat = 3.3
        let scaleValue = distanceDelta/(maxDistanceToCenter) * scalingFactor
        
        return scaleValue
    }
    
    func scale0(proxy: GeometryProxy, value: Int, center: CGPoint) -> CGFloat {
        let rowNumber = value / gridItems.count
        
        // We need to consider the offset for even rows!
        let x = (rowNumber % 2 == 0)
        ? proxy.frame(in: .global).midX + proxy.size.width/2
        : proxy.frame(in: .global).midX
        
        let y = proxy.frame(in: .global).midY
        //        let maxDistanceToCenter = getDistanceFromEdgeToCenter(x: x, y: y, center: center)
        let maxDistanceToCenter = center.x
        let currentPoint = CGPoint(x: x, y: y)
        let distanceFromCurrentPointToCenter = distanceBetweenPoints(p1: center, p2: currentPoint)
        
        // This creates a threshold for not just the pure center could get
        // the max scaleValue.
        
        let distanceDelta0 =  maxDistanceToCenter - distanceFromCurrentPointToCenter
        
        let distanceDelta = min(
            //            abs(distanceFromCurrentPointToCenter - maxDistanceToCenter),
            distanceDelta0 > 0 ? distanceDelta0 : 0,
            maxDistanceToCenter * 0.33
        )
        
        
        
        // Helps to get closer to scale 1.0 after the threshold.
        let scalingFactor:CGFloat = 3.3
        let scaleValue = distanceDelta/(maxDistanceToCenter) * scalingFactor
        
        return scaleValue
        
    }
    
    func isOutward(currentPoint: CGPoint, center: CGPoint) -> Bool {
        //        let (signX,signY) = (center.x - currentPoint.x, center.y - currentPoint.y)
        //        let bool: Bool = signX * signY > 0
        return (center.x - currentPoint.x) < 0
    }
    
    func getDistanceFromEdgeToCenter2(x: CGFloat, y: CGFloat, center: CGPoint) -> CGFloat {
        let m = slope(p1: CGPoint(x: x, y: y), p2: center)
        let currentAngle = angle(slope: m)
        
        let edgeSlope = slope(p1: .zero, p2: center)
        let deviceCornerAngle = angle(slope: edgeSlope)
        
        if currentAngle > deviceCornerAngle {
            let yEdge = (y > center.y) ? center.x*2 : 0
            let xEdge = (yEdge - y)/m + x
            let edgePoint = CGPoint(x: xEdge, y: yEdge)
            
            return distanceBetweenPoints(p1: center, p2: edgePoint)
        } else {
            let xEdge = (x > center.x) ? center.x*2 : 0
            let yEdge = m * (xEdge - x) + x
            let edgePoint = CGPoint(x: xEdge, y: yEdge)
            
            return distanceBetweenPoints(p1: center, p2: edgePoint)
        }
    }
    
    func getDistanceFromEdgeToCenter(x: CGFloat, y: CGFloat, center: CGPoint) -> CGFloat {
        let m = slope(p1: CGPoint(x: x, y: y), p2: center)
        let currentAngle = angle(slope: m)
        
        let edgeSlope = slope(p1: .zero, p2: center)
        let deviceCornerAngle = angle(slope: edgeSlope)
        
        if currentAngle > deviceCornerAngle {
            let yEdge = (y > center.y) ? center.y*2 : 0
            let xEdge = (yEdge - y)/m + x
            let edgePoint = CGPoint(x: xEdge, y: yEdge)
            
            return distanceBetweenPoints(p1: center, p2: edgePoint)
        } else {
            let xEdge = (x > center.x) ? center.x*2 : 0
            let yEdge = m * (xEdge - x) + y
            let edgePoint = CGPoint(x: xEdge, y: yEdge)
            
            return distanceBetweenPoints(p1: center, p2: edgePoint)
        }
    }
    
    func distanceBetweenPoints(p1: CGPoint, p2: CGPoint) -> CGFloat {
        let xDistance = abs(p2.x - p1.x)
        let yDistance = abs(p2.y - p1.y)
        
        return CGFloat(
            sqrt(
                pow(xDistance, 2) + pow(yDistance, 2)
            )
        )
    }
    
    func slope(p1: CGPoint, p2: CGPoint) -> CGFloat {
        return (p2.y - p1.y)/(p2.x - p1.x)
    }
    
    func angle(slope: CGFloat) -> CGFloat {
        return abs(atan(slope) * 180 / .pi)
    }
}


struct BubblesView_Previews: PreviewProvider {
    static var previews: some View {
        BubblesView()
            .environmentObject(EditViewModel())
    }
}
