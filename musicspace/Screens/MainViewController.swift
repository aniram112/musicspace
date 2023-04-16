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

protocol SlidersDelegate {
    func refreshSliders()
}

protocol SpaceDelegate {
    func setSpace(newSources: [AudioSource])
}


class MainViewController: UIViewController, SlidersDelegate, SpaceDelegate {
    var audioSpace = AudioSpace()
    lazy var audioSpaceView = AudioSpaceView(space: self.audioSpace)
    
    let savedButton = UIButton()
    let addButton = UIButton()
    let saveButton = UIButton()
    let clearButton = UIButton()
    
    let buttonStack   = UIStackView()
    let sliderStack   = UIStackView()
    
    let pitchSlider = PitchSlider(sliderRange: 1600)
    let speedSlider = SpeedSlider()
    let volumeSlider = UISlider()
    
    let motion = CMHeadphoneMotionManager()
    var emptyPlayer: AVAudioPlayer?
    var timer: Timer?
    
    let audioSource = AudioSource(
        audio: AudioFileModel.style,
        point: CGPoint(
            x: CGFloat.random(in: 0.1..<0.9),
            y: CGFloat.random(in: 0.1..<0.9)
        )
    )
    
    let audioSource2 = AudioSource(
        audio: AudioFileModel.blank,
        point: CGPoint(
            x: CGFloat.random(in: 0.1..<0.9),
            y: CGFloat.random(in: 0.1..<0.9)
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SavedData.loadData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"), style: .plain, target: self, action: #selector(openSaved))
        
        //UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(openSaved))
        view.backgroundColor = UIColor(.background)
        setupAudioSpace()
        setupAddButton()
        setupSliderStack()
        setupButtonStack()
        //audioSource.pitchControl.pitch = Float(pitchSlider.currentValue)
        pitchSlider.addTarget(self, action: #selector(pitchSliderMoved), for: .valueChanged)
        speedSlider.addTarget(self, action: #selector(speedSliderMoved), for: .valueChanged)
        volumeSlider.addTarget(self, action: #selector(volumeSliderMoved), for: .valueChanged)
        //audioSource.runAudio()
        //audioSource2.runAudio()
        //self.audioSpace.addSource(audioSource: audioSource)
        //self.audioSpace.addSource(audioSource: audioSource2)
        //addToSpace(file: AudioFileModel.style)
        for audio in self.audioSpace.sources {
            audio.runAudio()
        }
        guard self.motion.isDeviceMotionAvailable else { return }
        
       self.motion.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: {[weak self] motion, error  in
           guard let motion = motion, error == nil else { return }
            self?.processData(motion)
       })
        
        
    }
    
    
    func addToSpace(file: AudioFileModel){
        let audioSource = AudioSource(
            audio: file,
            point: CGPoint(
                x: CGFloat.random(in: 0.1..<0.9),
                y: CGFloat.random(in: 0.1..<0.9)
            )
        )
        self.audioSpace.addSource(audioSource: audioSource)
        for audio in self.audioSpace.sources {
            audio.runAudio()
        }
    }
    
    func refreshSliders() {
        //print("new node")
        pitchSlider.currentValue = CGFloat(audioSpaceView.selectedNode?.source?.pitchControl.pitch ?? 0)/pitchSlider.sliderRange
        speedSlider.value = audioSpaceView.selectedNode?.source?.speedControl.rate ?? 0
        volumeSlider.value = audioSpaceView.selectedNode?.source?.player?.volume ?? 0
    }
    
    @objc private func pitchSliderMoved() {
        audioSpaceView.selectedNode?.source?.pitch = Float(pitchSlider.currentValue * pitchSlider.sliderRange)
        //audioSource.pitchControl.pitch = Float(pitchSlider.currentValue * pitchSlider.sliderRange)
    }
    
    @objc private func speedSliderMoved() {
        //audioSource.speedControl.rate = speedSlider.value
        audioSpaceView.selectedNode?.source?.speed = speedSlider.value
    }
    
    @objc private func volumeSliderMoved() {
        //audioSource.player?.volume = volumeSlider.value
        audioSpaceView.selectedNode?.source?.player?.volume = volumeSlider.value
        
    }
    
    private func processData(_ data: CMDeviceMotion) {
        let angle = CGFloat(data.attitude.yaw)
        self.audioSpace.yaw = angle
        
        let deg = angle * CGFloat(180.0 / Double.pi)
        print(deg)
    }
    
    private func setupAudioSpace() {
        self.view.addSubview(self.audioSpaceView)
        audioSpaceView.delegate = self
        self.audioSpaceView.translatesAutoresizingMaskIntoConstraints = false
        self.audioSpaceView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 30).isActive = true
        self.audioSpaceView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        self.audioSpaceView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -30).isActive = true
    }
    
    private func setupAddButton() {
        self.view.addSubview(self.addButton)
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        self.addButton.topAnchor.constraint(equalTo: self.audioSpaceView.bottomAnchor, constant: 30).isActive = true
        self.addButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.addButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.addButton.backgroundColor = UIColor(.lightpurple)
        self.addButton.layer.cornerRadius = 15
        self.addButton.setTitle("+", for: .normal)
        self.addButton.titleLabel?.font =  .systemFont(ofSize: 30.0, weight: .regular)
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
        speedSlider.value = 1
        speedSlider.tintColor = .white
        speedSlider.maximumTrackTintColor = .lightGray
        speedSlider.awakeFromNib()
        
        volumeSlider.maximumValue = 1
        volumeSlider.minimumValue = 0
        volumeSlider.value = 0.5
        volumeSlider.tintColor = .white
        volumeSlider.maximumTrackTintColor = .lightGray
        
        self.sliderStack.addArrangedSubview(pitchSlider)
        self.sliderStack.addArrangedSubview(speedSlider)
        self.sliderStack.addArrangedSubview(volumeSlider)
        
        self.sliderStack.translatesAutoresizingMaskIntoConstraints = false
        self.sliderStack.topAnchor.constraint(equalTo: self.addButton.bottomAnchor, constant: 30).isActive = true
        self.sliderStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.pitchSlider.translatesAutoresizingMaskIntoConstraints = false
        self.pitchSlider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.pitchSlider.widthAnchor.constraint(equalTo: self.audioSpaceView.widthAnchor).isActive = true
        self.pitchSlider.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.speedSlider.translatesAutoresizingMaskIntoConstraints = false
        self.speedSlider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.speedSlider.widthAnchor.constraint(equalTo: self.audioSpaceView.widthAnchor, constant: -18).isActive = true
        self.speedSlider.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        self.volumeSlider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.volumeSlider.widthAnchor.constraint(equalTo: self.audioSpaceView.widthAnchor, constant: -18).isActive = true
        self.volumeSlider.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
        self.buttonStack.topAnchor.constraint(equalTo: sliderStack.bottomAnchor, constant: 15).isActive = true
        self.buttonStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.saveButton.translatesAutoresizingMaskIntoConstraints = false
        self.saveButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.saveButton.backgroundColor = UIColor(.lightpurple)
        self.saveButton.layer.cornerRadius = 15
        self.saveButton.setTitle("save", for: .normal)
        self.saveButton.titleLabel?.font =  .systemFont(ofSize: 20.0, weight: .regular)
        self.saveButton.addTarget(self, action: #selector(saveSpace), for: .touchUpInside)
        
        self.clearButton.translatesAutoresizingMaskIntoConstraints = false
        self.clearButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        self.clearButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.clearButton.backgroundColor = UIColor(.lightpurple)
        self.clearButton.layer.cornerRadius = 15
        self.clearButton.setTitle("clear", for: .normal)
        self.clearButton.titleLabel?.font =  .systemFont(ofSize: 20.0, weight: .regular)
        self.clearButton.addTarget(self, action: #selector(clearSpace), for: .touchUpInside)
    }
    
    
    @objc private func saveSpace() {
        let alert = UIAlertController(title: "Enter space name", message: "\n", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = "new space"
        }
        //alert.view.addSubview(pickerFrame)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { (UIAlertAction) in
                    guard let textField = alert.textFields?[0] else { return }
                    print("Text field: \(textField.text)")
                    // TODO
                    let mytime = Date()
                    let format = DateFormatter()
                    format.timeStyle = .short
                    format.dateStyle = .short
                    format.dateFormat = "dd.MM.yyyy HH:mm"
                    print(format.string(from: mytime))
                    let newSpace = SavedSpaceModel(name: textField.text ?? "new space", sources: self.audioSpace.sources, date: format.string(from: mytime))
                    SavedData.shared.spaces.append(newSpace)
                    SavedData.saveData()
                    
                }
            )
        )
        
        self.present(alert,animated: true, completion: nil )
    }
    
    func setSpace(newSources: [AudioSource]) {
        self.audioSpace.clearSources()
        for s in newSources {
            self.audioSpace.addSource(audioSource: s)
            s.runAudio()
        }
    }
    
    @objc private func clearSpace() {
        audioSpace.clearSources()
        //openSaved()
    }
    
    
    @objc private func openCollection() {
        for audio in self.audioSpace.sources{
            audio.stopAudio()
        }
        var colletionView = CollectionView()
        colletionView.action = addToSpace(file:)
        let collection = UIHostingController(rootView: colletionView)
        navigationController!.pushViewController(collection, animated: true)
    }
    
    @objc private func openSaved() {
        for audio in self.audioSpace.sources{
            audio.stopAudio()
        }
        var savedView = SavedView()
        savedView.delegate = self
        let saved = UIHostingController(rootView: savedView)
        navigationController!.pushViewController(saved, animated: true)
    }
    
}

