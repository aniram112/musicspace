//
//  CollectionCell.swift
//  musicspace
//
//  Created by Marina Roshchupkina on 08.04.2023.
//

import Foundation
import SwiftUI

struct CollectionCellView: View {
    var file: AudioFileModel
    @Binding var selectedCell: AudioFileModel?
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(selectedCell == file ? .accent : .lightpurple)
                    .frame(width: 60, height: 60)
                    .fixedSize()
                    .cornerRadius(15)
                
                Image(file.icon)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .frame(width: 45, height: 45)
                    
            }
            Text(getDisplayName(file.name)).font(.system(size: 11)).foregroundColor(.white)
        }.onTapGesture {
            selectedCell = file
        }
    }
    
    func getDisplayName(_ name: String) -> String {
        return String(name.split(separator: "/").last ?? "file")
    }
}
