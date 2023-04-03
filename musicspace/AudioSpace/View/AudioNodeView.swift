//
//  AudioNodeView.swift
//  musicspace
//
//  Created by Marina Roshchupkina on 22.03.2023.
//

import UIKit

class AudioNodeView: UIView {
    var frameView = UIView()
    var contentView = UIView()
    var imageView = UIImageView()
    var backgroundLight = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var source: AudioSource? {
        didSet {
            self.imageView.image = self.source?.audio.icon
        }
    }

    var volume: CGFloat = 0 {
        didSet {

        }
    }

    var selected: Bool = false {
        didSet {
            self.backgroundLight.isHidden = !self.selected
            if selected {
                self.contentView.transform = .init(scaleX: 1.12, y: 1.12)
                self.contentView.backgroundColor = .purple
            } else {
                self.contentView.transform = .identity
                self.contentView.backgroundColor = .white
            }
        }
    }

    var prepareToRemove: Bool = false {
        didSet {
            if self.prepareToRemove {
                self.alpha = 0.5
            } else {
                self.alpha = 1.0
            }
        }
    }

    func setup() {
        self.selected = false
        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)

        self.addSubview(self.backgroundLight)
        self.addSubview(self.frameView)
        self.addSubview(self.contentView)

        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 25
        self.contentView.layer.masksToBounds = true

        self.backgroundLight.image = UIImage(named: "selected_light")?.scalePreservingAspectRatio(targetSize: .init(width: 145, height: 145))
        self.backgroundLight.alpha = 0.25
        
        self.backgroundLight.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundLight.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        self.backgroundLight.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.contentView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        self.contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        self.contentView.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        self.imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
    }

    func playFallAnimation() {
        self.transform = CGAffineTransform(scaleX: 10, y: 10)
        self.alpha = 0

        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut]) {
            self.alpha = 1
            self.transform = .identity
        } completion: { _ in }
    }
}

