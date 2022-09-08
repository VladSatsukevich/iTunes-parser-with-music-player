//
//  MusicPlayerViewController.swift
//  iTunes
//
//  Created by VironIT on 26.08.22.
//
import AVKit
import SDWebImage
import UIKit

protocol FavoritePlayerViewControllerDelegate: AnyObject {
    func moveBack() -> FavoriteTrack?
    func moveForward() -> FavoriteTrack?
}

class FavoriteTracksPlayerViewController: UIViewController {
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var artistTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    var model: FavoriteTrack?
    var favoriteDelegate: FavoritePlayerViewControllerDelegate? //back-forward buttons delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerSetup(viewModel: model!)
    }
    
    func playerSetup(viewModel: FavoriteTrack){
        self.model = viewModel
        trackTitleLabel?.text = viewModel.trackName
        artistTitleLabel?.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        monitorTime()
        observeCurrentTime()
        let imageResize = viewModel.image!.replacingOccurrences(of: "100x100", with: "300x300")
        guard let url = URL(string: imageResize) else { return }
        trackImageView?.sd_setImage(with: url, completed: nil)
    }
    
    // MARK: - Player setup
    
    private func playTrack(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        NotificationCenter.default.addObserver(self, selector: #selector(trackDidEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    // MARK: - Player moving forward after track ending
    
    @objc private func trackDidEnded() {
        let model = favoriteDelegate?.moveForward()
        guard let buttonInfo = model else {
            return
        }
        self.playerSetup(viewModel: buttonInfo)
    }
    
    // MARK: - Time setup
    
    private func monitorTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.currentTimeLabel.text = time.timeDisplay()
        }
    }
    
    private func observeCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.timeDisplay()
            let durationTime = self?.player.currentItem?.duration
            let currentDurationTime = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).timeDisplay()
            self?.durationLabel.text = "-\(currentDurationTime)"
            self?.updateCurrentTime()
        }	
    }
    
    private func updateCurrentTime() {
        let currentTImeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime(value: 1, timescale: 1))
        let percentage = currentTImeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    
    // MARK: - Sliders setup
    
    @IBAction func handleVolumeSlider(_ sender: Any) {
        player.volume = volumeSlider.value
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    // MARK: - Buttons setup
    
    @IBAction func previousTrack(_ sender: Any) {
        let model = favoriteDelegate?.moveBack()
        guard let buttonInfo = model else {
            return
        }
        self.playerSetup(viewModel: buttonInfo)
    }
    
    @IBAction func nextTrack(_ sender: Any) {
        trackDidEnded()
    }
    
    @IBAction func playPauseButton(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            player.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
}

