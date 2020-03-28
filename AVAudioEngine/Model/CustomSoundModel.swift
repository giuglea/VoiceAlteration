//
//  CustomSoundModel.swift
//  AVAudioEngine
//
//  Created by Andrei Giuglea on 17/03/2020.
//  Copyright © 2020 Andrei Giuglea. All rights reserved.
//

import Foundation
import AVFoundation


class CustomSoundModel{
    
    var rate: Float?
    var pitch: Float?
    var echo: Bool
    var echoType: AVAudioUnitDistortionPreset
    var reverb: Bool
    var reverbType: AVAudioUnitReverbPreset
    var reverbDryMix: Float
    
    init(rate: Float?, pitch: Float?, echo:Bool = false, echoType: AVAudioUnitDistortionPreset, reverb: Bool = false, reverbType: AVAudioUnitReverbPreset, reverbDryMix: Float = 50) {
        self.rate = rate
        self.pitch = pitch
        self.echo = echo
        self.echoType = echoType
        self.reverb = reverb
        self.reverbType = reverbType
        self.reverbDryMix = reverbDryMix
    }
    
}
