//
//  SavedView.swift
//  musicspace
//
//  Created by Marina Roshchupkina on 15.12.2022.
//

import SwiftUI

struct SavedSpaceModel {
    var name: String
    var sources: [AudioSource]
    var date: String
    // TODO
    
}


struct SavedView: View {
    @Environment(\.presentationMode) var presentationMode
    var delegate: SpaceDelegate?
    
    
    var body: some View {
        List{
            ForEach(Data.shared.spaces, id: \.name) { item in
                record(model: item).padding(.bottom, 20).swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        //store.delete(message)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .background(Color.background.ignoresSafeArea())
    }
    
    func delete(at offsets: IndexSet) {
        print("deleting")
        //users.remove(atOffsets: offsets)
    }
    
    func record(model: SavedSpaceModel) -> some View {
        return ZStack{
            Rectangle().foregroundColor(.lightpurple).frame(width: 330, height: 80).fixedSize().cornerRadius(20)
            HStack(alignment: .center, spacing: 0){
                VStack(alignment: .leading){
                    Text(model.name)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    Text(model.date)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    
                }
                Spacer()
                Image(systemName: "play.circle")
                    .resizable()
                    .frame(width:50, height: 50)
                    .foregroundColor(.white)
            }.frame(width: 300, height: 80).fixedSize()
        }.listRowBackground(Color.background)
        .onTapGesture {
            openSpace(model.sources)
            
        }
        
        
    }
    
    private func openSpace(_ sources: [AudioSource]) {
        let audioSource = AudioSource(
            audio: AudioFileModel.style,
            point: CGPoint(
                x: CGFloat.random(in: 0.1..<0.9),
                y: CGFloat.random(in: 0.1..<0.9)
            ),
            range: 0.5
        )
        
        let audioSource2 = AudioSource(
            audio: AudioFileModel.blank,
            point: CGPoint(
                x: CGFloat.random(in: 0.1..<0.9),
                y: CGFloat.random(in: 0.1..<0.9)
            ),
            range: 0.5
        )
        
        audioSource.pitchControl.pitch = -800
        //audioSource.pitchControl.pitch = -800
        for i in sources {
            print("pitch: \(i.pitchControl.pitch)")
        }
        delegate?.setSpace(newSources: sources)
        self.presentationMode.wrappedValue.dismiss()
        
    }
}

struct SavedView_Previews: PreviewProvider {
    static var previews: some View {
        SavedView()
    }
}
