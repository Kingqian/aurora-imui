//
//  IMUIAudioPlayerHelper.swift
//  IMUIChat
//
//  Created by oshumini on 2017/3/9.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import AVFoundation

protocol IMUIAudioPlayerDelegate:NSObjectProtocol {
  func didAudioPlayerBeginPlay(_ AudioPlayer:AVAudioPlayer)
  func didAudioPlayerStopPlay(_ AudioPlayer:AVAudioPlayer)
  func didAudioPlayerPausePlay(_ AudioPlayer:AVAudioPlayer)
}

class IMUIAudioPlayerHelper: NSObject {
  static let sharedInstance = IMUIAudioPlayerHelper()
  
  var player:AVAudioPlayer!
  weak var delegate:IMUIAudioPlayerDelegate?
  
  override init() {
    super.init()
    
  }
  
  func managerAudioWithData(_ data:Data, toplay:Bool) {
    if toplay {
      self.playAudioWithData(data)
    } else {
      self.pausePlayingAudio()
    }
  }
  
  open func playAudioWithData(_ voiceData:Data) {
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
    } catch let error as NSError {
      print("set category fail \(error)")
    }
    
    if self.player != nil {
      self.player.stop()
      self.player = nil
    }
    
    do {
      let voicePlayer:AVAudioPlayer = try AVAudioPlayer(data: voiceData)
      voicePlayer.delegate = self
      voicePlayer.play()
      self.player = voicePlayer
    } catch let error as NSError {
      print("alloc AVAudioPlayer with voice data fail with error \(error)")
    }
    
    UIDevice.current.isProximityMonitoringEnabled = true
  }
  
  func pausePlayingAudio() {
    self.player?.pause()
  }
  
  func stopAudio() {
    if self.player.isPlaying {
      self.player.stop()
    }
    
    UIDevice.current.isProximityMonitoringEnabled = false
    self.delegate?.didAudioPlayerStopPlay(self.player)
  }
}


// MARK: - AVAudioPlayerDelegate
extension IMUIAudioPlayerHelper: AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    self.stopAudio()
  }
}
