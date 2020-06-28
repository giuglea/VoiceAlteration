//
//  SoundSettings.swift
//  AVAudioEngine
//
//  Created by Andrei Giuglea on 15/03/2020.
//  Copyright © 2020 Andrei Giuglea. All rights reserved.
//

import UIKit
import AVFoundation

class SoundSettings: UIViewController, UIGestureRecognizerDelegate {

    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    var customSoundArray = [CustomSoundModel]()
    
    let database = Database()
    
    @IBOutlet weak var uiCollectionView: UICollectionView!
    

    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCustomSounds()
        setupAudio()
        setUpLongTapGesture()
        
        
      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureUI(.notPlaying)
        loadCustomSounds()
        
        
        
    }
    
    func setUpLongTapGesture(){
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.uiCollectionView.addGestureRecognizer(longPressGesture)
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
            
        }
        

        configureUI(.playing)
    }
    
    
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        stopAudio()
    }
    
    func loadCustomSounds(){
        customSoundArray = database.getCustomSounds()
        uiCollectionView.reloadData()
        
    }
    
    


}


extension SoundSettings: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return customSoundArray.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionSoundButton", for: indexPath) as? CustomSoundCell else{
            return UICollectionViewCell()
            
        }
        
        if indexPath.row != customSoundArray.count/*-1*/ {
           cell.customSoundImage.image = UIImage(systemName: "mic.fill")
        }
        else{
             cell.customSoundImage.image = UIImage(systemName: "plus.app")
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == customSoundArray.count{
            performSegue(withIdentifier: "NewCustomSound", sender: nil)
        }else{
            print(indexPath.row)
            print("Aci sunt: " + String(customSoundArray.count))
            customSoundArray[indexPath.row].printModel()
            playCustomSound(customSound: customSoundArray[indexPath.row])
        }
      //TODO: Add delete/update gesture
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewCustomSound"{
            let  createCustomSound = segue.destination as! CreeateCustomSoundVC 
            createCustomSound.recordedAudioURL = recordedAudioURL
            
        }
    }
    
    
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer){
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began{
            let touchPoint = longPressGestureRecognizer.location(in: self.uiCollectionView)
            if  let indexPath = uiCollectionView.indexPathForItem(at: touchPoint){
                if indexPath.row < customSoundArray.count{
                    let printed = customSoundArray[indexPath.row]
                    print(printed.echo)
                }
                
            }
            
        }
    }
    
    
}
