//
//  SavedView.swift
//  musicspace
//
//  Created by Marina Roshchupkina on 15.12.2022.
//

import SwiftUI

struct SavedSpaceModel {
    // TODO
    
}


struct SavedView: View {
    var body: some View {
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            VStack{
                ScrollView {
                    record.padding(.top,30)
                    record.padding(.top,30)
                    record.padding(.top,30)
                    record.padding(.top,30)
                    record.padding(.top,30)
                    record.padding(.top,30)
                    record.padding(.top,30)
                    record.padding(.top,30)
                }.padding(.top,20)
                //.scrollIndicators(.hidden)
            }

        }
    }
    
    var record: some View {
        ZStack{
            Rectangle().foregroundColor(.lightpurple).frame(width: 330, height: 80).fixedSize().cornerRadius(20)
            HStack{
                VStack(alignment: .leading){
                    Text("Song title")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    Text("02.06.2002 23:59")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    
                }.padding(.trailing,50)
                Image(systemName: "play.circle")
                    .resizable()
                    .frame(width:50, height: 50)
                    .foregroundColor(.white)
            }
        }
        
    }
    
    private func openSpace() {
        // TODO
    }
}

struct SavedView_Previews: PreviewProvider {
    static var previews: some View {
        SavedView()
    }
}
