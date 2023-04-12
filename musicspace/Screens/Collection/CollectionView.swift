//
//  CollectionView.swift
//  musicspace
//
//  Created by Marina Roshchupkina on 15.12.2022.
//

import SwiftUI
import AVFoundation

struct CollectionView: View {
    //let data = (1...100).map { "Item \($0)" }
    @Environment(\.presentationMode) var presentationMode
    @State var data = AudioFileModel.collection["drums"]
    var categoriesArray = Array(AudioFileModel.collection.keys.sorted())
    let columns = [GridItem(.adaptive(minimum: 70))]
    var action: (_ file: AudioFileModel) -> Void = {file in }
    @State var selectedFile: AudioFileModel?
    @State var audioSource =  AudioSource(
        audio:  .kick,
        point: CGPoint(
            x: 0.5,
            y: 0.5
        ),
        range: 0.5
    )
    
    var body: some View {
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20){
                categories
                    .padding(.top,40)
                    .padding(.horizontal,20)
                grid
                HStack(alignment: .center, spacing: 40) {
                    button(text: "Add", action: {addSound(file: selectedFile)})
                    button(text: "Try", action: {playSound()})
                }
            }
        }
    }
    
    
    var categories: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 20){
                ForEach(categoriesArray, id: \.self) { item in
                    category(name: item)
                }
            }
        }//.scrollIndicators(.hidden)
    }
    
    func category(name: String) -> some View {
        return Text(name)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.white)
            .onTapGesture {
                self.data = AudioFileModel.collection[name]
            }
    }
    
    var grid: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(data ?? [], id: \.self) { item in
                    CollectionCellView(file: item, selectedCell: self.$selectedFile)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func button(text: String, action: @escaping () -> Void) -> some View {
        return Button(action: action){
            HStack(alignment: .center, spacing: 10) {
                Text(text)
                    .font(.system(size: 25, weight: .bold))
                
            }.frame(width: 120,height: 55)
                .background(Color.accent)
                .cornerRadius(15)
                .foregroundColor(.black)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    
    private func playSound() {
        guard let selectedFile else {return}
        self.audioSource = AudioSource(
            audio: selectedFile,
            point: CGPoint(
                x: 0.5,
                y: 0.5
            ),
            range: 0.5
        )
        self.audioSource.runAudio()
        
        let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
            print("Timer fired!")
            self.audioSource.stopAudio()
        }
        
    }
    
    private func addSound(file: AudioFileModel?) {
        guard let file else {return}
        action(file)
        //delegate?.addToSpace(file: file)
        self.audioSource.stopAudio()
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
