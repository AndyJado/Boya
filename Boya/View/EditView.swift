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
    var edition: Int = 1
    
}

class EditViewModel: ObservableObject {
    
    //TODO: pieces for words actually
    private let fileName4pieces = "pieces"
    private let fileName4wordsPop = "popWords"
    private let fileName4threads = "threads"
    
    //commit & push words
    @Published var aword = Aword()
    @Published var popword: Aword? = nil
    
    // layer 1
    @Published var wordsPop:[Aword] = []
    @Published var wordsPool:[Aword] = []
    
    // layer 2.
    @Published var threads: [String : [Aword]] = [:]
    // keys vector for threads
    @Published var clues: [String] = ["Pop","..."]
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getData()
    }
    
    func getData() {
        loadWords()
        loadThreads()
    }
    
    
    // pull layer 2
    func chosenthread(pickerAt index:Int) -> [Aword] {
        return threads[clues[index]] ?? wordsPop
    }
    
    // Push layer 1
    func Pressed(pickerAt index:Int) {
        // guard pop happened!
        guard let pop = popword else {return}
        // the clue
        let text = pop.text
        // dynamic array
        let endIndex = clues.count - 1
        
        switch index {
            case endIndex:
                clues.insert(text, at: 1)
                threads[text] = [pop]
                saveThreads()
            case 0:
                wordsPop.append(pop)
                savePops()
            default:
                threads[clues[index]]?.append(pop)
                saveThreads()
        }
        popword = nil
        savePieces()
    }
    
    func submitted() {
        
        if aword.text == "" {
            aword = Aword()
        } else {
            withAnimation {
                wordsPool.append(aword)
            }
            savePieces()
            aword = Aword()
        }
        
    }
    
    func word2clue(word: Aword) {
        
        if let piece = threads[word.text] {
            print(piece.description)
        } else {
            print(threads.description)
        }
    }
    
    
    func loadThreads() {
        
        do {
            let url4threads = try LocalFileManager.fileURL(fileName: fileName4threads)
            
            URLSession.shared.dataTaskPublisher(for: url4threads)
                .receive(on: DispatchQueue.main)
                .tryMap(handleOutput)
                .decode(type: [[String : [Aword]]].self, decoder: JSONDecoder())
                .replaceError(with: [])
                .sink(receiveValue: { [weak self] returned in
                    guard let self = self else {return}
                    if !returned.isEmpty {
                        self.threads = returned[0]
                        let keys = self.threads.keys
                        self.clues.insert(contentsOf: keys , at: 1)
                    }
                })
                .store(in: &cancellables)
            
        } catch {
            print("try LocalFileManager.fileURL()")
        }
        
        
    }
    
    func loadWords() {
        do {
            let url4pieces = try LocalFileManager.fileURL(fileName: fileName4pieces)
            let url4pops = try LocalFileManager.fileURL(fileName: fileName4wordsPop)
            
            URLSession.shared.dataTaskPublisher(for: url4pieces)
                .receive(on: DispatchQueue.main)
                .tryMap(handleOutput)
                .decode(type: [Aword].self, decoder: JSONDecoder())
                .replaceError(with: [])
                .sink(receiveValue: { [weak self] returnedPieces in
                    self?.wordsPool = returnedPieces
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
    }
    
    func savePieces() {
        
        LocalFileManager.save(aCodable: wordsPool, fileName: fileName4pieces)
        print("save savePieces( ) data")
    }
    
    func savePops() {
        LocalFileManager.save(aCodable: wordsPop, fileName: fileName4wordsPop)
        print("save  savePops()  data")
    }
    
    func saveThreads() {
        LocalFileManager.save(aCodable: [threads], fileName: fileName4threads)
        print("saveThreads()")
    }
    
    func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        
        return output.data
    }
    
}

struct EditView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject var viewModel:EditViewModel = EditViewModel()
    
    @State private var picking:Int = 0
    
    @State private var pickerOn:Bool = false
    @State private var threadOn:Bool = false
    
    
    @FocusState private var focuing: Bool
    
    
    var body: some View {
        
        let contentFocus:Bool = focuing || pickerOn
        
        let pressAction = {
            viewModel.Pressed(pickerAt: picking)
            if picking >= 1 { picking -= 1 }
            
        }
        
        NavigationView {
            ZStack {
                // 双击退回编辑 (没有保存动作)
                // 长按进入pop (pop保存)
                LazyGridView(items: $viewModel.wordsPool, currentItem: $viewModel.aword, currentPop: $viewModel.popword, tap2Action: {focuing.toggle()}, pressAction: pressAction)
                    .opacity(contentFocus ? 0.35 : 1)
                    .blur(radius: contentFocus ? 1.6 : 0)
                    .disabled(contentFocus)
                
                VStack(alignment: .center, spacing: 0) {
                    TypeIn(theWord: $viewModel.aword, dragged2: $threadOn, dragged1: $pickerOn, focuing: $focuing.wrappedValue)
                        .focused($focuing)
                        .onSubmit {
                            viewModel.submitted()
                            focuing = true
                        }
                    
                    if pickerOn {
                        PickView(clues: $viewModel.clues, picking: $picking)
                            .disabled(focuing)
                    } else if !focuing {
                        Text(viewModel.clues[picking])
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .padding(.horizontal, 40)
                            .frame( height: 20, alignment: .center)
                    } else {
                        EmptyView()
                    }
                }
                .animation(Animation.easeInOut, value: pickerOn)
                
                NavigationLink("", isActive: $threadOn) {
                    PieceView(picking: picking)
                }
            }
            .onTapGesture {
                withAnimation {
                    focuing.toggle()
                }
            }
        }
        .navigationBarHidden(true)
        .environmentObject(viewModel)
    }
    
}
struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
