//
//  AudioFileModel.swift
//  musicspace
//
//  Created by Marina Roshchupkina on 22.03.2023.
//

import Foundation
import AVFoundation
import UIKit

struct AudioFileModel: Hashable, Codable {
    enum File: String, Codable {
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
    var icon: String
}

extension AudioFileModel {
    static var style: AudioFileModel {
        return AudioFileModel(name: "style", file: .mp3, icon: "microphone")
    }
    
    static var blank: AudioFileModel {
        return AudioFileModel(name: "blank_space", file: .mp3, icon: "microphone")
    }
    
    static var kick: AudioFileModel {
        return AudioFileModel(name: "Drums/kick", file: .wav, icon: "kick")
    }
    
    static var snare: AudioFileModel {
        return AudioFileModel(name: "Drums/snare", file: .wav, icon: "snare")
    }
    
    static var hat: AudioFileModel {
        return AudioFileModel(name: "Drums/hi-hat", file: .wav, icon:  "hi-hat")
    }
    
    static var cymbal: AudioFileModel {
        return AudioFileModel(name: "Drums/cymbal", file: .wav, icon: "hi-hat")
    }
    
    static var clap: AudioFileModel {
        return AudioFileModel(name: "Drums/clap", file: .wav, icon: "clap")
    }
    
    static var synth: AudioFileModel {
        return AudioFileModel(name: "synth", file: .mp3, icon: "piano")
    }
    
    
    static var xylo: AudioFileModel {
        return AudioFileModel(name: "Ambient/xylo", file: .wav, icon: "xylophone")
    }
    
    static var woodblock: AudioFileModel {
        return AudioFileModel(name: "Ambient/woodblock", file: .wav, icon: "woodblock")
    }
    
    static var stringReverse: AudioFileModel {
        return AudioFileModel(name: "Ambient/string reverse", file: .wav, icon: "piano")
    }
    
    static var paradise: AudioFileModel {
        return AudioFileModel(name: "Ambient/paradise pad", file: .wav, icon: "piano")
    }
    
    static var lowFlutes: AudioFileModel {
        return AudioFileModel(name: "Ambient/low flutes", file: .wav, icon: "flute")
    }
    
    static var keys: AudioFileModel {
        return AudioFileModel(name: "Ambient/keys", file: .wav, icon: "piano")
    }
    
    static var guitar: AudioFileModel {
        return AudioFileModel(name: "Ambient/guitar", file: .wav, icon:  "guitar-instrument")
    }
    
    static var dreamArp: AudioFileModel {
        return AudioFileModel(name: "Ambient/dream arp", file: .wav, icon: "piano")
    }
    
    static var cowbell: AudioFileModel {
        return AudioFileModel(name: "Ambient/cowbell", file: .wav, icon: "cowbell")
    }
    
    
    static var absorb: AudioFileModel {
        return AudioFileModel(name: "Glitch Drums/absorb", file: .wav, icon: "glitch")
    }
    
    static var crawler: AudioFileModel {
        return AudioFileModel(name: "Glitch Drums/crawler", file: .wav, icon: "glitch")
    }
    
    static var freezer: AudioFileModel {
        return AudioFileModel(name: "Glitch Drums/freezer", file: .wav, icon: "glitch")
    }
    
    static var dagger: AudioFileModel {
        return AudioFileModel(name: "Glitch Drums/dagger", file: .wav, icon: "glitch")
    }
    
    static var smoke: AudioFileModel {
        return AudioFileModel(name: "Glitch Drums/smoke", file: .wav, icon: "glitch")
    }
    
    static var spurt: AudioFileModel {
        return AudioFileModel(name: "Glitch Drums/spurt", file: .wav, icon: "glitch")
    }
    
    static var stuffy: AudioFileModel {
        return AudioFileModel(name: "Glitch Drums/stuffy", file: .wav, icon: "glitch")
    }
    
    static var Bm: AudioFileModel {
        return AudioFileModel(name: "Guitars/guitar Bm", file: .wav, icon: "guitar-instrument")
    }
    
    static var Cm: AudioFileModel {
        return AudioFileModel(name: "Guitars/guitar C#m", file: .wav, icon: "guitar-instrument")
    }
    
    static var Em: AudioFileModel {
        return AudioFileModel(name: "Guitars/guitar Em", file: .wav, icon:  "guitar-instrument")
    }
    
    static var Fm: AudioFileModel {
        return AudioFileModel(name: "Guitars/guitar Fm", file: .wav, icon: "guitar-instrument")
    }
    
    static var Gm: AudioFileModel {
        return AudioFileModel(name: "Guitars/guitar Gm", file: .wav, icon: "guitar-instrument")
    }
    
    
    static var collection = [
        "Drums" : [AudioFileModel.kick, AudioFileModel.snare,
                   AudioFileModel.hat, AudioFileModel.clap,
                   AudioFileModel.cymbal],
        "Glitch Drums" : [AudioFileModel.absorb, AudioFileModel.crawler,
                          AudioFileModel.freezer, AudioFileModel.dagger,
                          AudioFileModel.smoke, AudioFileModel.spurt,
                          AudioFileModel.stuffy],
        "Guitars" : [AudioFileModel.Bm, AudioFileModel.Cm,
                     AudioFileModel.Em, AudioFileModel.Fm,
                     AudioFileModel.Gm],
        "Secret" : [AudioFileModel.synth],
        "Ambient" : [AudioFileModel.xylo, AudioFileModel.woodblock,
                     AudioFileModel.stringReverse, AudioFileModel.paradise,
                     AudioFileModel.lowFlutes, AudioFileModel.keys,
                     AudioFileModel.guitar, AudioFileModel.dreamArp,
                     AudioFileModel.cowbell],
    ]
}
