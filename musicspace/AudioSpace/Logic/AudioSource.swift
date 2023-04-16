//
//  AudioSource.swift
//  musicspace
//
//  Created by Marina Roshchupkina on 22.03.2023.
//
import UIKit
import AVFoundation

class AudioSource: Codable {
    let audio: AudioFileModel
    var point: CGPoint
    var pitch: Float = 0 {
        didSet {
            pitchControl.pitch = pitch
        }
    }
    var speed: Float = 1.0 {
        didSet {
            speedControl.rate = speed
        }
    }
    var addAnimation: Bool
    
    var onRemoveState: Bool {
        didSet {
            self.updateVolume()
        }
    }
    
    var yaw: CGFloat = 0 {
        didSet {
            self.updateAudioResult()
        }
    }
    
    init(audio: AudioFileModel, point: CGPoint, addAnimation: Bool = true) {
        self.audio = audio
        self.point = point
        self.addAnimation = addAnimation
        self.onRemoveState = false
        
        //self.runAudio()
        
        self.updateAudioResult()
        self.updateVolume()
    }
    
    private enum CodingKeys: String, CodingKey {
        case audio
        case point
        case pitch
        case speed
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        audio = try values.decode(AudioFileModel.self, forKey: .audio)
        point = try values.decode(CGPoint.self, forKey: .point)
        pitch = try values.decode(Float.self, forKey: .pitch)
        speed = try values.decode(Float.self, forKey: .speed)
        pitchControl.pitch = self.pitch
        speedControl.rate = self.speed
        addAnimation = true
        onRemoveState = false
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(audio, forKey: .audio)
        try container.encode(point, forKey: .point)
        try container.encode(pitch, forKey: .pitch)
        try container.encode(speed, forKey: .speed)
    }
    
    func convert(fullSize: CGSize) -> CGPoint {
        return CGPoint(x: fullSize.width * point.x, y: fullSize.height * point.y)
    }
    
    func applyFrom(viewPoint: CGPoint, insideSize: CGSize) {
        let x = viewPoint.x / insideSize.width
        let y = viewPoint.y / insideSize.height
        
        if x < 0 || y < 0 || x > 1 || y > 1 {
            self.onRemoveState = true
        } else {
            self.point = CGPoint(x: x, y: y)
            self.onRemoveState = false
        }
        
        self.updateAudioResult()
        self.updateVolume()
        SavedData.saveData()
    }
    
    func updateVolume() {
        self.player?.volume = self.onRemoveState ? 0 : Float(self.volume)
    }
    
    func updateAudioResult() {
        self.player?.pan = Float(self.audioResult(v1: self.userVector, v2: self.getVectorOnCircle))
        //print("x:\(self.point.x) y:\(self.point.y)")
    }
    
    var getVectorOnCircle: Vector2D {
        return Vector2D(
            (self.point.x - 0.5) * 2,
            (self.point.y - 0.5) * 2
        )
    }
    
    var player: AVAudioPlayerNode?
    let engine = AVAudioEngine()
    let speedControl = AVAudioUnitVarispeed()
    let pitchControl = AVAudioUnitTimePitch()
    let buffer = AVAudioPCMBuffer()
    
    var distance: CGFloat {
        let vector = self.getVectorOnCircle
        return sqrt(vector.x * vector.x + vector.y * vector.y)
    }
    
    var volume: CGFloat {
        let distance = self.distance
        var volumeValue = max((1 - (max(distance, 0.2) - 0.2)), 0)
        volumeValue = max(volumeValue, 0.05)
        return volumeValue
    }
    
    var timer: Timer?
    
    func stopAudio() {
        self.player?.stop()
        self.timer?.invalidate()
    }
    
    func runAudio() {
        guard let url = Bundle.main.url(forResource: self.audio.name, withExtension: self.audio.file.rawValue) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            let file = try AVAudioFile(forReading: url)
            self.player = try AVAudioPlayerNode()
            guard let player = self.player else { return }
            let audioFormat = file.processingFormat
            let audioFrameCount = UInt32(file.length)
            let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
            
            engine.attach(player)
            engine.attach(pitchControl)
            engine.attach(speedControl)
            
            engine.connect(player, to: speedControl, format: audioFileBuffer?.format)
            engine.connect(speedControl, to: pitchControl, format: audioFileBuffer?.format)
            engine.connect(pitchControl, to: engine.mainMixerNode, format: audioFileBuffer?.format)
            
            try engine.start()
            try file.read(into: audioFileBuffer!, frameCount: audioFrameCount)
            player.play()
            player.scheduleBuffer(audioFileBuffer!, at: nil, options:.loops, completionHandler: nil)
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    var userVector: Vector2D {
        var vector = Vector2D(1, 0)
        vector = vector.rotated(by: -self.yaw)
        return vector
    }
    
    func audioResult(v1: Vector2D, v2: Vector2D) -> CGFloat {
        let angle = v1.angelBetweenCurrentAnd(vector: v2)
        var deg = angle * CGFloat(180.0 / Double.pi)
        deg = abs(deg)
        
        var result: CGFloat
        if deg > 90 {
            let value = (180 - deg) / 90
            result = -1 + value - 0.07
        } else {
            let value = deg / 90
            result = 1 - value + 0.07
        }
        
        return self.normalizeAudioResultByVolume(result: result)
    }
    
    private func normalizeAudioResultByVolume(result: CGFloat) -> CGFloat {
        let volume = self.volume
        return result - result * pow(volume, 3)
    }
}


