//
//  SoundVC.swift
//  Musica
//
//  Created by Bouziane Bey on 21/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import UIKit
import AVFoundation

class SoundVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        countUpLabel.text = formatted(time: 0)
        countDownLabel.text = formatted(time: audioLengthSeconds)
        setupAudio()
        
        updater = CADisplayLink(target: self, selector: #selector(updateUI))
        updater?.add(to: .current, forMode: .default)
        updater?.isPaused = true
    }
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var countUpLabel: UILabel!
    @IBOutlet weak var skipForwardBtn: UIButton!
    @IBOutlet weak var skipBackwardBtn: UIButton!
    @IBOutlet weak var playpauseBtn: UIButton!
    
    var engine = AVAudioEngine()
    var player = AVAudioPlayerNode()
    var audioBufeer : AVAudioPCMBuffer?
    
    // MARK: other properties
    var audioFormat: AVAudioFormat?
    var audioSampleRate: Float = 0
    var audioLengthSeconds: Float = 0
    var audioLengthSamples: AVAudioFramePosition = 0
    var needsFileScheduled = true
    var updater: CADisplayLink?
    
    var currentFrame: AVAudioFramePosition{
        guard let lastRenderTime = player.lastRenderTime,
        let playerTime = player.playerTime(forNodeTime: lastRenderTime)
            else {
                return 0
        }
        return playerTime.sampleTime
    }
    
    var seekFrame: AVAudioFramePosition = 0
    var currentPosition: AVAudioFramePosition = 0
    let pauseImageHeight: Float = 26.0
    let minDb: Float = -80.0
    
    enum TimeConstant {
        static let secsPerMin = 60
        static let secsPerHour = TimeConstant.secsPerMin * 60
    }
    
    var audioFile: AVAudioFile? {
        didSet{
            if let audioFile = audioFile{
                audioLengthSamples = audioFile.length
                audioFormat = audioFile.processingFormat
                audioSampleRate = Float(audioFormat?.sampleRate ?? 44100)
                audioLengthSeconds = Float(audioLengthSamples) / audioSampleRate
            }
        }
    }
    
    var audioFileURL: URL?{
        didSet{
            if let audioFileURL = audioFileURL{
                audioFile = try? AVAudioFile(forReading: audioFileURL)
            }
        }
    }
    
    @IBAction func playTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if player.isPlaying{
            updater?.isPaused = true
            let image = UIImage(named: "play")
            sender.setImage(image, for: .normal)
            player.pause()
        } else {
            if needsFileScheduled{
                needsFileScheduled = false
                scheduleAudioFile()
            }
            updater?.isPaused = false
            let image = UIImage(named: "pause")
            sender.setImage(image, for: .normal)
            player.play()
        }
    }
    
    @IBAction func plus10Tapped(_ sender: Any) {
        guard let _ = player.engine else {return}
        seek(to: 10.0)
    }
    
    @IBAction func minus10Tapped(_ sender: Any) {
        guard let _ = player.engine else {return}
        needsFileScheduled = false
        seek(to: -10.0)
    }
    
    @objc func updateUI() {
        currentPosition = currentFrame + seekFrame
        currentPosition = max(currentPosition, 0)
        currentPosition = min(currentPosition, audioLengthSamples)
        
        progressBar.progress = Float(currentPosition) / Float(audioLengthSamples)
        let time = Float(currentPosition) / audioSampleRate
        countUpLabel.text = formatted(time: time)
        countDownLabel.text = formatted(time: Float(audioLengthSeconds) - time)
        
        if currentPosition >= audioLengthSamples{
            player.stop()
            updater?.isPaused = true
            playpauseBtn.isSelected = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent{
            player.stop()
        }
    }
    
    func formatted(time: Float) -> String {
    var secs = Int(ceil(time))
    var hours = 0
    var mins = 0
    
    if secs > TimeConstant.secsPerHour {
    hours = secs / TimeConstant.secsPerHour
    secs -= hours * TimeConstant.secsPerHour
    }
    
    if secs > TimeConstant.secsPerMin {
    mins = secs / TimeConstant.secsPerMin
    secs -= mins * TimeConstant.secsPerMin
    }
    
    var formattedString = ""
    if hours > 0 {
    formattedString = "\(String(format: "%02d", hours)):"
    }
    formattedString += "\(String(format: "%02d", mins)):\(String(format: "%02d", secs))"
    return formattedString
    }
    
    // MARK: - Audio
    func setupAudio() {
        audioFileURL = Bundle.main.url(forResource: "Purple_Haze", withExtension: "mp3")
        
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: audioFormat)
        engine.prepare()
        
        do{
            try engine.start()
        } catch let error{
            print(error.localizedDescription)
        }
    }
    
    func scheduleAudioFile() {
        guard let audioFile = audioFile else {return}
        seekFrame = 0
        player.scheduleFile(audioFile, at: nil) { [weak self] in
            self?.needsFileScheduled = true
        }
    }
    
    func seek(to time: Float) {
        guard let audioFile = audioFile, let updater = updater
            else {
                return
        }
        
        seekFrame = currentPosition + AVAudioFramePosition(time * audioSampleRate)
        seekFrame = max(seekFrame, 0)
        seekFrame = min(seekFrame, audioLengthSamples)
        currentPosition = seekFrame
        
        player.stop()
        
        if currentPosition < audioLengthSamples{
            updateUI()
            needsFileScheduled = false
            
            player.scheduleSegment(audioFile, startingFrame: seekFrame, frameCount: AVAudioFrameCount(audioLengthSamples - seekFrame), at: nil) {
                [weak self] in
                self?.needsFileScheduled = true
            }
            if !updater.isPaused{
                player.play()
            }
        }
    }
}
