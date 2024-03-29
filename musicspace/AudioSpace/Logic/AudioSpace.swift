//
//  AudioSpace.swift
//  musicspace
//
//  Created by Marina Roshchupkina on 22.03.2023.
//

import UIKit
import Combine

protocol AudioSpaceDelegate: AnyObject {
    func addAudioSource(audioSource: AudioSource)
    func removeAudioSource(audioSource: AudioSource)
}

class AudioSpace {
    var sources: [AudioSource] = []
    weak var delegate: AudioSpaceDelegate?

    var yaw: CGFloat = 0 {
        didSet {
            self.sources.forEach({ $0.yaw = self.yaw })
        }
    }

    func addSource(audioSource: AudioSource) {
        self.sources.append(audioSource)
        self.delegate?.addAudioSource(audioSource: audioSource)
    }

    func removeSource(audioSource: AudioSource) {
        audioSource.stopAudio()
        self.sources.removeAll(where: { $0 === audioSource })
        self.delegate?.removeAudioSource(audioSource: audioSource)
    }
    
    func clearSources() {
        for audio in sources {
            removeSource(audioSource: audio)
        }
    }
}
