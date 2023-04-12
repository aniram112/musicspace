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
        return AudioFileModel(name: "KICK", file: .wav, icon: UIImage(named: "kick")!)
    }
    
    static var synth: AudioFileModel {
        return AudioFileModel(name: "synth", file: .mp3, icon: UIImage(named: "piano")!)
    }
    
    static var collection = [
        "songs" : [AudioFileModel.style, AudioFileModel.blank],
        "drums" : [AudioFileModel.kick],
        "secret" : [AudioFileModel.synth],
    ]
}
