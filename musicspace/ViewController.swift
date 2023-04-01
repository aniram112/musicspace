//
//  ViewController.swift
//  musicspace
//
//  Created by Marina Roshchupkina on 14.12.2022.
//

import UIKit
import SwiftUI
import CoreMotion
import AVFoundation

class ViewController: UIViewController {
    let audioSpace = AudioSpace()
    lazy var audioSpaceView = AudioSpaceView(space: self.audioSpace)
    lazy var addButton = UIButton()
    lazy var saveButton = UIButton()
    lazy var clearButton = UIButton()
    lazy var buttonStack   = UIStackView()
    lazy var sliderStack   = UIStackView()
    lazy var pitchSlider = PitchSlider(sliderRange: 1400)
    lazy var speedSlider = UISlider()//SpeedSlider(sliderRange: 2)
    
    let motion = CMHeadphoneMotionManager()
    var emptyPlayer: AVAudioPlayer?
    var timer: Timer?
    
    let audioSource = AudioSource(
        audio: AudioFileModel.synth,
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(.background)
        setupAudioSpace()
        setupAddButton()
        setupSliderStack()
        setupButtonStack()
        //audioSource.pitchControl.pitch = Float(pitchSlider.currentValue)
        pitchSlider.addTarget(self, action: #selector(pitchSliderMoved), for: .valueChanged)
        speedSlider.addTarget(self, action: #selector(speedSliderMoved), for: .valueChanged)
        audioSource.runAudio()
        self.audioSpace.addSource(audioSource: audioSource)
        //self.audioSpace.addSource(audioSource: audioSource2)
        
        guard self.motion.isDeviceMotionAvailable else { return }

       self.motion.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: {[weak self] motion, error  in
           guard let motion = motion, error == nil else { return }
            self?.processData(motion)
       })
    
       
    }
    @objc func pitchSliderMoved() {
        audioSource.pitchControl.pitch = Float(pitchSlider.currentValue * pitchSlider.sliderRange)

    }
    
    @objc func speedSliderMoved() {
        audioSource.speedControl.rate = speedSlider.value//Float(speedSlider.currentValue * speedSlider.sliderRange)
       //print("slider moved \(speedSlider.currentValue * speedSlider.sliderRange)")
        print("slider moved \(speedSlider.value)")
    }
    
    func processData(_ data: CMDeviceMotion) {
        let angle = CGFloat(data.attitude.yaw)
        self.audioSpace.yaw = angle

        let deg = angle * CGFloat(180.0 / Double.pi)
        print(deg)
    }
    
    private func setupAudioSpace() {
        self.view.addSubview(self.audioSpaceView)
        self.audioSpaceView.translatesAutoresizingMaskIntoConstraints = false
        self.audioSpaceView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 40).isActive = true
        self.audioSpaceView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 90).isActive = true
        self.audioSpaceView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -40).isActive = true
    }
    
    private func setupAddButton() {
        self.view.addSubview(self.addButton)
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        self.addButton.topAnchor.constraint(equalTo: self.audioSpaceView.bottomAnchor, constant: 50).isActive = true
        self.addButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.addButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.addButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.addButton.backgroundColor = UIColor(.lightpurple)
        self.addButton.layer.cornerRadius = 20
        self.addButton.setTitle("+", for: .normal)
        self.addButton.titleLabel?.font =  .systemFont(ofSize: 40.0, weight: .regular)
        self.addButton.addTarget(self, action: #selector(openCollection), for: .touchUpInside)
    }
    
    private func setupSliderStack() {
        self.view.addSubview(self.sliderStack)
        self.sliderStack.axis  = NSLayoutConstraint.Axis.vertical
        self.sliderStack.distribution  = UIStackView.Distribution.equalSpacing
        self.sliderStack.alignment = UIStackView.Alignment.center
        self.sliderStack.spacing = 30
        
        speedSlider.maximumValue = 4
        speedSlider.minimumValue = 0
        speedSlider.tintColor = .white
        
        self.sliderStack.addArrangedSubview(pitchSlider)
        self.sliderStack.addArrangedSubview(speedSlider)
        
        self.sliderStack.translatesAutoresizingMaskIntoConstraints = false
        self.sliderStack.topAnchor.constraint(equalTo: self.addButton.bottomAnchor, constant: 50).isActive = true
        self.sliderStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.pitchSlider.translatesAutoresizingMaskIntoConstraints = false
        self.pitchSlider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.pitchSlider.widthAnchor.constraint(equalTo: self.audioSpaceView.widthAnchor).isActive = true
        self.pitchSlider.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.speedSlider.translatesAutoresizingMaskIntoConstraints = false
        self.speedSlider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.speedSlider.widthAnchor.constraint(equalTo: self.audioSpaceView.widthAnchor).isActive = true
        self.speedSlider.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
    
    private func setupButtonStack() {
        self.view.addSubview(self.buttonStack)
        self.buttonStack.axis  = NSLayoutConstraint.Axis.horizontal
        self.buttonStack.distribution  = UIStackView.Distribution.equalSpacing
        self.buttonStack.alignment = UIStackView.Alignment.center
        self.buttonStack.spacing = 60
        
        self.buttonStack.addArrangedSubview(saveButton)
        self.buttonStack.addArrangedSubview(clearButton)
        
        self.buttonStack.translatesAutoresizingMaskIntoConstraints = false
        self.buttonStack.topAnchor.constraint(equalTo: sliderStack.bottomAnchor, constant: 50).isActive = true
        self.buttonStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.saveButton.translatesAutoresizingMaskIntoConstraints = false
        self.saveButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.saveButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.saveButton.backgroundColor = UIColor(.lightpurple)
        self.saveButton.layer.cornerRadius = 20
        self.saveButton.setTitle("save", for: .normal)
        self.saveButton.titleLabel?.font =  .systemFont(ofSize: 30.0, weight: .regular)
        self.saveButton.addTarget(self, action: #selector(saveSpace), for: .touchUpInside)
        
        self.clearButton.translatesAutoresizingMaskIntoConstraints = false
        self.clearButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.clearButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.clearButton.backgroundColor = UIColor(.lightpurple)
        self.clearButton.layer.cornerRadius = 20
        self.clearButton.setTitle("clear", for: .normal)
        self.clearButton.titleLabel?.font =  .systemFont(ofSize: 30.0, weight: .regular)
        self.clearButton.addTarget(self, action: #selector(clearSpace), for: .touchUpInside)
    }
    
    
    @objc func saveSpace() {
        
    }
    
    @objc func clearSpace() {
        audioSpace.clearSources()
    }
    
    
    @objc func openCollection() {
        let collection = UIHostingController(rootView: CollectionView())
        navigationController!.pushViewController(collection, animated: true)
    }
    
    @objc func openSaved() {
        let saved = UIHostingController(rootView: SavedView())
        navigationController!.pushViewController(saved, animated: true)
    }
    
}

