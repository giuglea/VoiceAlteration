//
//  SoundSettings.swift
//  AVAudioEngine
//
//  Created by Andrei Giuglea on 15/03/2020.
//  Copyright © 2020 Andrei Giuglea. All rights reserved.
//

import UIKit
import AVFoundation

class SoundSettings: UIViewController {

    var recordedAudioURL: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    var customSoundButtons = [CustomSoundModel]()
    
    @IBOutlet weak var uiCollectionView: UICollectionView!
    

    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb, custom
    }
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
   // @IBOutlet weak var customButton: UIButton!
    
    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAudio()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureUI(.notPlaying)
        
        
        
    }
    
    @IBAction func playSoundButton(_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 700)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        case .custom:
            playCustomSound(rate: 1, pitch: -500, echo: true, echoType: .drumsBitBrush, reverb: true, reverbType: .largeChamber, reverbDryMix: 30)
        }
        

        configureUI(.playing)
    }
    
    
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        stopAudio()
    }
    
    func loadCustomSounds(){
        
    }
    
    


}


extension SoundSettings: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2//customSoundButtons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //customCollectionSoundButton
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionSoundButton", for: indexPath) as? CustomSoundCell else{
            return UICollectionViewCell()
            
        }
        
        if indexPath.row == customSoundButtons.count/*-1*/ {
            cell.customSoundImage.image = UIImage(systemName: "plus.app")
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == customSoundButtons.count{
            performSegue(withIdentifier: "NewCustomSound", sender: nil)
        }else{
            //play sound
        }
      // UILongPressGestureRecognizer()
    }
    
    
}
