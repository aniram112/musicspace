//
//  MainScreenView.swift
//  musicspace
//
//  Created by Marina Roshchupkina on 14.12.2022.
//

import SwiftUI

struct MainScreenModel {
    let onPlusTap: () -> Void
    let onSavedTap: () -> Void
    
}
struct MainScreenView: View {
    let model: MainScreenModel
    @State private var slidervalueOne: Double = 0
    @State private var slidervalueTwo: Double = 0
    @State private var slidervalueThree: Double = 0
    @State private var slidervalueFour: Double = 0
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20){
                Space
                button(text: "+", action: model.onPlusTap)
                ScrollView {
                    slider(value: $slidervalueOne).padding(.bottom,20)
                    slider(value: $slidervalueTwo).padding(.bottom,20)
                    slider(value: $slidervalueThree).padding(.bottom,20)
                    slider(value: $slidervalueFour).padding(.bottom,20)
                }//.scrollIndicators(.hidden).padding(.bottom,20)
                HStack(alignment: .center, spacing: 40) {
                    button(text: "Save", action: model.onSavedTap)
                    button(text: "Clear", action: {})
                }
            }
        }
    }
    
    
    var Space: some View {
        Rectangle().foregroundColor(.white).frame(width: 290, height: 290).fixedSize().cornerRadius(20)
    }
    
    private func button(text: String, action: @escaping () -> Void) -> some View {
        return Button(action: action){
            HStack(alignment: .center, spacing: 10) {
                Text(text)
                    .font(.system(size: 25, weight: .bold))
                    
            }.frame(width: 120,height: 55)
                .background(Color.lightpurple)
                .cornerRadius(15)
                .foregroundColor(.white)
        }
        .buttonStyle(ScaleButtonStyle())
        
    
    }
    
    private func slider(value: Binding<Double>) -> some View {
        VStack(alignment: .leading,spacing: 5){
            Text("something")
                .padding(.horizontal,20)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            Slider(value: value, in: -100...100)
                .tint(.white)
                .padding(.horizontal,20)
        }
    }
    
    
}

public struct ScaleButtonStyle: ButtonStyle {
    
    public init(scaleEffect: CGFloat = 0.96, duration: Double = 0.15) {
        self.scaleEffect = scaleEffect
        self.duration = duration
    }
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .scaleEffect(configuration.isPressed ? scaleEffect : 1)
            .animation(.easeInOut(duration: duration), value: configuration.isPressed)
    }
    
    private let scaleEffect: CGFloat
    private let duration: Double
}

/// Previews
struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView(model: MainScreenModel(onPlusTap: {}, onSavedTap: {}))
    }
}


