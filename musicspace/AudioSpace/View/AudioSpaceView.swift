//
//  AudioSpaceView.swift
//  musicspace
//
//  Created by Marina Roshchupkina on 22.03.2023.
//

import Foundation
import UIKit

class AudioSpaceView: UIView, AudioSpaceDelegate {
    var delegate: SlidersDelegate?
    var contentView = UIView()

    var space: AudioSpace

    var backgroundView = UIView()
    var userImageView = UIImageView(image: UIImage(named: "icon_user_2"))
    var audioSpaceNodes: [AudioNodeView] = []

    init(space: AudioSpace) {
        self.space = space
        super.init(frame: .zero)
        self.setup()
    }

    func addAudioSource(audioSource: AudioSource) {
        let node = AudioNodeView()
        node.source = audioSource
        self.audioSpaceNodes.append(node)
        self.contentView.addSubview(node)

        self.updatePosition(node: node, audioSource: audioSource)

        if audioSource.addAnimation {
            node.playFallAnimation()
        }

        self.lastAddedNode = node
    }

    func removeAudioSource(audioSource: AudioSource) {
        guard let node = self.audioSpaceNodes.first(where: { $0.source === audioSource }) else {
            return
        }

        self.audioSpaceNodes.removeAll(where: { $0 === node })
        node.removeFromSuperview()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        for node in self.audioSpaceNodes {
            if let source = node.source {
                self.updatePosition(node: node, audioSource: source)
            }
        }
    }

    func updatePosition(node: AudioNodeView, audioSource: AudioSource) {
        node.center = audioSource.convert(fullSize: self.frame.size)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var timer: Timer?

    func setup() {
        self.addSubview(self.contentView)

        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 12
        self.backgroundView.layer.cornerRadius = 12
        self.backgroundView.layer.masksToBounds = true
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.contentView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        self.contentView.addSubview(self.backgroundView)
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.backgroundView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.backgroundView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.backgroundView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        
        self.backgroundView.addSubview(self.userImageView)
        self.userImageView.backgroundColor = .purple//UIColor(.background)
        self.userImageView.layer.cornerRadius = 17
        self.userImageView.translatesAutoresizingMaskIntoConstraints = false
        self.userImageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        self.userImageView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        self.userImageView.centerXAnchor.constraint(equalTo: self.backgroundView.centerXAnchor).isActive = true
        self.userImageView.centerYAnchor.constraint(equalTo: self.backgroundView.centerYAnchor).isActive = true

        for source in self.space.sources {
            self.addAudioSource(audioSource: source)
        }
        self.space.delegate = self
    }

    var selectedNode: AudioNodeView? {
        didSet {
            if selectedNode != nil{
                delegate?.refreshSliders()
            }
        }
    }
    weak var lastAddedNode: AudioNodeView?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.selectedNode = nil
        for node in self.audioSpaceNodes{
            node.selected = false
        }
        var foundNode = false

        guard let touch = touches.first else {
            return
        }

        let position = touch.location(in: self)

        for node in self.audioSpaceNodes {
            if node.frame.contains(position) {
                self.selectedNode = node
                self.selectedNode?.selected.toggle()
                foundNode = true
                break
            }
        }
        if !foundNode {
            for node in self.audioSpaceNodes{
                node.selected = false
            }
        }

    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        guard let touch = touches.first,
              let selectedNode = self.selectedNode else {
            return
        }

        let position = touch.location(in: self)
        var itemFrame = CGRect(
            x: position.x - selectedNode.frame.width / 2,
            y: position.y - selectedNode.frame.height / 2,
            width: selectedNode.frame.width,
            height: selectedNode.frame.height
        )

        let percentage = self.bounds.intersectionPercentage(itemFrame)
        if percentage != 0 {
            if itemFrame.origin.x < 0 {
                itemFrame.origin.x = 0
            }

            if itemFrame.origin.y < 0 {
                itemFrame.origin.y = 0
            }

            if itemFrame.maxX > self.frame.width {
                itemFrame.origin.x = self.frame.width - itemFrame.width
            }

            if itemFrame.maxY > self.frame.height {
                itemFrame.origin.y = self.frame.height - itemFrame.height
            }

            selectedNode.center = CGPoint(
                x: itemFrame.midX,
                y: itemFrame.midY
            )
            selectedNode.prepareToRemove = false
        } else {
            selectedNode.center = position
            selectedNode.prepareToRemove = true
        }

        selectedNode.source?.applyFrom(
            viewPoint: selectedNode.center,
            insideSize: self.bounds.size
        )
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.touchEndActions()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.touchEndActions()
    }

    private func touchEndActions() {
        //self.selectedNode?.selected = false
        if self.selectedNode?.prepareToRemove == true, let source = self.selectedNode?.source {
            self.space.removeSource(audioSource: source)
        }
        //self.selectedNode = nil
    }
}

public extension CGRect {
    func intersectionPercentage(_ otherRect: CGRect) -> CGFloat {
        if !intersects(otherRect) { return 0 }
        let intersectionRect = intersection(otherRect)
        if intersectionRect == self || intersectionRect == otherRect { return 100 }
        let intersectionArea = intersectionRect.width * intersectionRect.height
        let area = width * height
        return (intersectionArea / area) * 100
    }
}
