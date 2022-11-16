//
//  PlayVideoViewController.swift
//  SH_SS
//
//  Created by phạm Hưng on 8/28/20.
//  Copyright © 2020 phạm Hưng. All rights reserved.
//

import UIKit
import BMPlayer
import AVFoundation
import NVActivityIndicatorView

func delay(_ seconds: Double, completion:@escaping ()->()) {
  let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
  
  DispatchQueue.main.asyncAfter(deadline: popTime) {
    completion()
  }
}

class PlayVideoViewController: UIViewController {
  
  //    @IBOutlet weak var player: BMPlayer!
  
  var player: BMPlayer!
  
  var index: IndexPath!
  
  var changeButton = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    preparePlayer()
    setupPlayerManager()
    setupPlayerResource()
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(applicationDidEnterBackground),
                                           name: UIApplication.didEnterBackgroundNotification,
                                           object: nil)
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(applicationWillEnterForeground),
                                           name: UIApplication.willEnterForegroundNotification,
                                           object: nil)
  }
  
  @objc func applicationWillEnterForeground() {
    
  }
  
  @objc func applicationDidEnterBackground() {
    player.pause(allowAutoPlay: false)
  }
  /**
    prepare playerView
    */
   func preparePlayer() {
   player = BMPlayer()
   view.addSubview(player)
   player.snp.makeConstraints { (make) in
       make.top.equalTo(self.view).offset(20)
       make.left.right.equalTo(self.view)
       // Note here, the aspect ratio 16:9 priority is lower than 1000 on the line, because the 4S iPhone aspect ratio is not 16:9
       make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(500)
   }
   // Back button event
   player.backBlock = { [unowned self] (isFullScreen) in
       if isFullScreen == true { return }
       let _ = self.navigationController?.popViewController(animated: true)
   }
}
  
  
  func setupPlayerResource() {
    let asset = BMPlayerResource(url: URL(string: "http://appapi.sunhouse.com.vn/ApiDocument/VideoFiles/KPI/Video/19-08-2020/HUNGPV2_132423035810010000.mp4")!)
    player.setVideo(resource: asset)
 
  }
  
  // 设置播放器单例，修改属性
  func setupPlayerManager() {
   resetPlayerManager()
//    switch (index.section,index.row) {
//    // 普通播放器
//    case (0,0):
//      break
//    case (0,1):
//      break
//    case (0,2):
//      // 设置播放器属性，此情况下若提供了cover则先展示封面图，否则黑屏。点击播放后开始loading
//      BMPlayerConf.shouldAutoPlay = false
//
//    case (1,0):
//      // 设置播放器属性，此情况下若提供了cover则先展示封面图，否则黑屏。点击播放后开始loading
//      BMPlayerConf.topBarShowInCase = .always
//
//
//    case (1,1):
//      BMPlayerConf.topBarShowInCase = .horizantalOnly
//
//
//    case (1,2):
//      BMPlayerConf.topBarShowInCase = .none
//
//    case (1,3):
//      BMPlayerConf.tintColor = UIColor.red
//
//    default:
//      break
//    }
  }
  
  

  
  
  func resetPlayerManager() {
    BMPlayerConf.allowLog = false
    BMPlayerConf.shouldAutoPlay = true
    BMPlayerConf.tintColor = UIColor.white
    BMPlayerConf.topBarShowInCase = .always
    BMPlayerConf.loaderType  = NVActivityIndicatorType.ballRotateChase
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
    // If use the slide to back, remember to call this method
    // 使用手势返回的时候，调用下面方法
     //self.navigationController?.setNavigationBarHidden(false, animated: animated)
    player.pause(allowAutoPlay: true)
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
    // If use the slide to back, remember to call this method
    // 使用手势返回的时候，调用下面方法
    //self.navigationController?.setNavigationBarHidden(true, animated: animated)
   
    player.autoPlay()
  }
  
  deinit {
    // If use the slide to back, remember to call this method
    // 使用手势返回的时候，调用下面方法手动销毁
    player.prepareToDealloc()
    print("VideoPlayViewController Deinit")
  }
  
}

// MARK:- BMPlayerDelegate example
extension PlayVideoViewController: BMPlayerDelegate {
  // Call when player orinet changed
  func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
    player.snp.remakeConstraints { (make) in
      make.top.equalTo(view.snp.top)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      if isFullscreen {
        make.bottom.equalTo(view.snp.bottom)
      } else {
        make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0).priority(500)
      }
    }
  }
  
  // Call back when playing state changed, use to detect is playing or not
  func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
    print("| BMPlayerDelegate | playerIsPlaying | playing - \(playing)")
  }
  
  // Call back when playing state changed, use to detect specefic state like buffering, bufferfinished
  func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
    print("| BMPlayerDelegate | playerStateDidChange | state - \(state)")
  }
  
  // Call back when play time change
  func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
    //        print("| BMPlayerDelegate | playTimeDidChange | \(currentTime) of \(totalTime)")
  }
  
  // Call back when the video loaded duration changed
  func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
    //        print("| BMPlayerDelegate | loadedTimeDidChange | \(loadedDuration) of \(totalDuration)")
  }
}
