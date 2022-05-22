//
//  EditView.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/17.
//

import SwiftUI
import Combine


struct Aword:Hashable, Codable {
    
    var text: String = ""
    var secondSpent: Int = 0
    var edition: Int = 0
    
}

class EditViewModel: ObservableObject {
    
    private let fileName4pieces = "pieces"
    private let fileName4wordsPop = "popWords"
    
    
    @Published var aword = Aword()
    @Published var wordsPop:[Aword] = []
    @Published var pieces:[Aword] = []
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getData()
        timeCount()
    }
    
    func submitted() {
        
        if aword.text == "" {
            aword = Aword()
        } else {
            pieces.append(aword)
            savePieces()
            aword = Aword()
        }
        
    }
    
    
    func timeCount() {
        Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.aword.secondSpent += 1
            }
            .store(in: &cancellables)
    }
    
    func getData() {
        do {
            let url4pieces = try LocalFileManager.fileURL(fileName: fileName4pieces)
            let url4pops = try LocalFileManager.fileURL(fileName: fileName4wordsPop)
            
            URLSession.shared.dataTaskPublisher(for: url4pieces)
                .receive(on: DispatchQueue.main)
                .tryMap(handleOutput)
                .decode(type: [Aword].self, decoder: JSONDecoder())
                .replaceError(with: [])
                .sink(receiveValue: { [weak self] returnedPieces in
                    self?.pieces = returnedPieces
                })
                .store(in: &cancellables)
            
            URLSession.shared.dataTaskPublisher(for: url4pops)
                .receive(on: DispatchQueue.main)
                .tryMap(handleOutput)
                .decode(type: [Aword].self, decoder: JSONDecoder())
                .replaceError(with: [])
                .sink(receiveValue: { [weak self] returnedpops in
                    self?.wordsPop = returnedpops
                })
                .store(in: &cancellables)
            
        } catch {
            print("try LocalFileManager.fileURL()")
        }
        
        func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
            
            return output.data
        }
        
    }
    
    func savePieces() {
        LocalFileManager.save(pieces: pieces, fileName: fileName4pieces)
        print("save savePieces( ) data")
    }
    
    func savePops() {
        LocalFileManager.save(pieces: wordsPop, fileName: fileName4wordsPop)
        print("save  savePops()  data")
    }
    
    
}

struct EditView: View {
    
    @StateObject var viewModel = EditViewModel()
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var pinched:Bool = false
    
    @FocusState private var focuing: Bool
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                // 双击退回编辑 (没有保存动作)
                // 长按进入pop (pop保存)
                LazyGridView(items: $viewModel.pieces, currentWord: $viewModel.aword, popeditems: $viewModel.wordsPop, action: viewModel.savePops)
                
                TypeIn(textInField: $viewModel.aword.text)
                    .focused($focuing)
                    .onSubmit {
                        viewModel.submitted()
                        focuing = true
                    }
                    .onTapGesture {
                        focuing.toggle()
                    }
                
                NavigationLink("", isActive: $pinched) {
                    StealWallView()
                }
                
            }
            .onReceive(viewModel.$wordsPop) { _ in
            }
            .onChange(of: scenePhase) { phase in
                if phase == .active {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        self.focuing = true
                    }
                }
            }
            .gesture(
                MagnificationGesture()
                    .onChanged{ CGval in
                        print(CGval.description)
                        if CGval < 1 {
                            self.pinched.toggle()
                            print(CGval.description)
                        }
                    }
            )
            
            
            
            
        }
    }
    
}
struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
