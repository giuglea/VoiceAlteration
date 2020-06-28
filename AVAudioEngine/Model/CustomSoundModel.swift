//
//  CustomSoundModel.swift
//  AVAudioEngine
//
//  Created by Andrei Giuglea on 17/03/2020.
//  Copyright © 2020 Andrei Giuglea. All rights reserved.
//

import Foundation
import AVFoundation


class CustomSoundModel:Equatable{
    
    
   
    
    
    var rate: Float?
    var pitch: Float?
    var echo: Bool
    var echoType: AVAudioUnitDistortionPreset
    var reverb: Bool
    var reverbType: AVAudioUnitReverbPreset
    var reverbDryMix: Float
    
    init(rate: Float? = 1, pitch: Float? = 0, echo:Bool = false, echoType: AVAudioUnitDistortionPreset = .drumsBitBrush, reverb: Bool = false, reverbType: AVAudioUnitReverbPreset = .cathedral, reverbDryMix: Float = 0) {
        self.rate = rate
        self.pitch = pitch
        self.echo = echo
        self.echoType = echoType
        self.reverb = reverb
        self.reverbType = reverbType
        self.reverbDryMix = reverbDryMix
    }
    
    
    func printModel(){
        print("Rate: ",rate)
        print("Pitch: ",pitch)
        print("Echo: ",echo)
        print("EchoType: ",echoType)
        print("Reverb: ",reverb)
        print("ReverbType: ",reverbType)
        print("ReverbDryMix: ",reverbDryMix)
        
        
    }
    
    static func == (lhs: CustomSoundModel, rhs: CustomSoundModel) -> Bool {
        if lhs.rate != rhs.rate {return false}
        if lhs.pitch != rhs.pitch {return false}
        if lhs.echo != rhs.echo {return false}
        if lhs.echoType != rhs.echoType {return false}
        if lhs.reverb != rhs.reverb {return false}
        if lhs.reverbType != rhs.reverbType {return false}
        if lhs.reverbDryMix != rhs.reverbDryMix {return false}
        
        return true
        
    }
    
}
