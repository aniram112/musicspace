//
//  SavedView.swift
//  musicspace
//
//  Created by Marina Roshchupkina on 15.12.2022.
//

import SwiftUI

struct SavedSpaceModel: Codable {
    var name: String
    var sources: [AudioSource]
    var date: String
}


struct SavedView: View {
    @Environment(\.presentationMode) var presentationMode
    var delegate: SpaceDelegate?
    
    
    var body: some View {
        List{
            ForEach(SavedData.shared.spaces, id: \.name) { item in
                record(model: item).padding(.bottom, 20).swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        delete(item: item)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .background(Color.background.ignoresSafeArea())
    }
    
    func delete(item: SavedSpaceModel) {
        SavedData.shared.spaces.removeAll(where: {$0.name == item.name})
        SavedData.saveData()
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
        }
        .listRowBackground(Color.background)
        .listRowSeparator(.hidden)
        .onTapGesture {
            openSpace(model.sources)
            
        }
        
        
    }
    
    private func openSpace(_ sources: [AudioSource]) {
        delegate?.setSpace(newSources: sources)
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct SavedView_Previews: PreviewProvider {
    static var previews: some View {
        SavedView()
    }
}
