//
//  SpeedSlider.swift
//  musicspace
//
//  Created by Marina Roshchupkina on 02.04.2023.
//

import Foundation
import UIKit
class SpeedSlider: UISlider {
    var thumbTextLabel: UILabel = UILabel()
    
    private var thumbFrame: CGRect {
        return thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
    }
    
    private lazy var thumbView: UIView = {
        let thumb = UIView()
        return thumb
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        thumbTextLabel.frame = CGRect(x: thumbFrame.origin.x, y: thumbFrame.minY-30, width: thumbFrame.size.width, height: 30)
        self.setValue()
    }
    
    private func setValue() {
        thumbTextLabel.text =  String(format: "%0.2f", self.value)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(thumbTextLabel)
        thumbTextLabel.textAlignment = .center
        thumbTextLabel.textColor = .white
        thumbTextLabel.font = UIFont(name: "Futura Medium", size: 15)
        thumbTextLabel.layer.zPosition = layer.zPosition + 1
        thumbTextLabel.adjustsFontSizeToFitWidth = true
    }
}
