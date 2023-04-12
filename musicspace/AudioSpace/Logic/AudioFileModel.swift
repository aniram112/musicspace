//
//  AudioFileModel.swift
//  musicspace
//
//  Created by Marina Roshchupkina on 22.03.2023.
//

import Foundation
import AVFoundation
import UIKit

struct AudioFileModel: Hashable {
    enum File: String {
        case mp3
        case wav

        var type: AVFileType {
            switch self {
            case .mp3:
                return AVFileType.mp3
            case .wav:
                return AVFileType.wav
            }
        }
    }

    var name: String
    var file: File
    var icon: UIImage

    static var style: AudioFileModel {
        return AudioFileModel(name: "style", file: .mp3, icon: UIImage(named: "microphone")!)
    }
    
    static var blank: AudioFileModel {
        return AudioFileModel(name: "blank_space", file: .mp3, icon: UIImage(named: "microphone")!)
    }
    
    static var kick: AudioFileModel {
        return AudioFileModel(name: "kick", file: .wav, icon: UIImage(named: "kick")!)
    }
    
    static var snare: AudioFileModel {
        return AudioFileModel(name: "snare", file: .wav, icon: UIImage(named: "snare")!)
    }
    
    static var hat: AudioFileModel {
        return AudioFileModel(name: "hi-hat", file: .wav, icon: UIImage(named: "hi-hat")!)
    }
    
    static var cymbal: AudioFileModel {
        return AudioFileModel(name: "cymbal", file: .wav, icon: UIImage(named: "hi-hat")!)
    }
    
    static var clap: AudioFileModel {
        return AudioFileModel(name: "clap", file: .wav, icon: UIImage(named: "clap")!)
    }
    
    static var synth: AudioFileModel {
        return AudioFileModel(name: "synth", file: .mp3, icon: UIImage(named: "piano")!)
    }
    
    static var collection = [
        "drums" : [AudioFileModel.kick, AudioFileModel.snare, AudioFileModel.hat,
                   AudioFileModel.clap, AudioFileModel.cymbal],
        "songs" : [AudioFileModel.style, AudioFileModel.blank],
        "secret" : [AudioFileModel.synth],
    ]
}
