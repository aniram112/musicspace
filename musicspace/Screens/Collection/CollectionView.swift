//
//  CollectionView.swift
//  musicspace
//
//  Created by Marina Roshchupkina on 15.12.2022.
//

import SwiftUI

struct CollectionView: View {
    let data = (1...100).map { "Item \($0)" }

    let columns = [
            GridItem(.adaptive(minimum: 80))
        ]
    
    var body: some View {
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20){
                categories
                    .padding(.top,40)
                    .padding(.horizontal,20)
                grid
                HStack(alignment: .center, spacing: 40) {
                    button(text: "Add", action: {})
                    button(text: "Try", action: {})
                }
            }
        }
    }
    
    
    var categories: some View {
        ScrollView(.horizontal){
            HStack(spacing: 20){
                Text("Category")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Text("Category")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Text("Category")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Text("Category")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Text("Category")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Text("Category")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
        }//.scrollIndicators(.hidden)
    }
    
    var grid: some View {
        ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(data, id: \.self) { item in
                            Rectangle().foregroundColor(.lightpurple).frame(width: 60, height: 60).fixedSize().cornerRadius(15)
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
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
