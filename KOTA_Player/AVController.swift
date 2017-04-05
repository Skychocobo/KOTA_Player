//
//  AVController.swift
//  KOTA_Player
//
//  Created by  noble on 2016. 11. 2..
//  Copyright © 2016년 KOTA. All rights reserved.
//

import UIKit
import AVFoundation

class AVController: UIViewController {
    
    @IBOutlet weak var fileTitle: UILabel!
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var playButton:UIButton?
    var playbackSlider:UISlider?
    
    var playerItemName = ""
    var playerImgName = ""
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fileTitle.text = SharingManager.sharedInstance.fileTitle
        
        self.playerItemName = SharingManager.sharedInstance.fileName
        self.playerImgName = SharingManager.sharedInstance.imgName
        
        let imgUrl = URL(string: "http://ocarinamr.com/upload/app/"+playerImgName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        let imgData = try? Data(contentsOf: imgUrl!)
        img.image = UIImage(data: imgData!)
        
        self.automaticallyAdjustsScrollViewInsets = true
        
        let url = URL(string: "http://ocarinamr.com/upload/app/"+playerItemName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        
        let playerLayer=AVPlayerLayer(player: player!)
        playerLayer.frame=CGRect(x: 0, y: 0, width: 10, height: 50)
        self.view.layer.addSublayer(playerLayer)
        
        playButton = UIButton(type: UIButtonType.system) as UIButton
        let xPostion:CGFloat = 50
        let yPostion:CGFloat = 300
        let buttonWidth:CGFloat = 150
        let buttonHeight:CGFloat = 45
        
        playButton!.frame = CGRect(x: xPostion, y: yPostion, width: buttonWidth, height: buttonHeight)
        playButton!.backgroundColor = UIColor.lightGray
        playButton!.setTitle("Play", for: UIControlState.normal)
        playButton!.tintColor = UIColor.black
        //playButton!.addTarget(self, action: "playButtonTapped:", forControlEvents: .TouchUpInside)
        playButton!.addTarget(self, action: #selector(AVController.playButtonTapped(_:)), for: .touchUpInside)
        
        self.view.addSubview(playButton!)
        
        
        // Add playback slider
        
        playbackSlider = UISlider(frame:CGRect(x: (self.view.frame.size.width/2)-150, y: 300, width: 300, height: 20))
        playbackSlider!.minimumValue = 0
        
        
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        
        playbackSlider!.maximumValue = Float(seconds)
        playbackSlider!.isContinuous = true
        playbackSlider!.tintColor = UIColor.green
        
        playbackSlider?.addTarget(self, action: #selector(AVController.playbackSliderValueChanged(_:)), for: .valueChanged)
        //playbackSlider!.addTarget(self, action: "playbackSliderValueChanged:", for: .valueChanged)
        self.view.addSubview(playbackSlider!)
        
        UIView.animate(withDuration: seconds) {
            self.img.center.y -= self.view.bounds.height
        }
        
        
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                self.playbackSlider!.value = Float ( time );
            }
        }
        
        player!.play()
        player!.rate = 1
        playButton!.setTitle("Pause", for: UIControlState.normal)
        
        
    }
    
    func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            player?.play()
        }
    }
    
    
    func playButtonTapped(_ sender:UIButton)
    {
        if player?.rate == 0
        {
            player!.play()
            //playButton!.setImage(UIImage(named: "player_control_pause_50px.png"), forState: UIControlState.Normal)
            playButton!.setTitle("Pause", for: UIControlState.normal)
        } else {
            player!.pause()
            //playButton!.setImage(UIImage(named: "player_control_play_50px.png"), forState: UIControlState.Normal)
            playButton!.setTitle("Play", for: UIControlState.normal)
        }
    }
    
    @IBAction func forword(_ sender: UIButton, forEvent event: UIEvent) {
        player!.pause()
    }
    
}
