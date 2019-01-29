//
//  ViewController.swift
//  AppleMusicKitDemo
//
//  Created by Chaman Gurjar on 28/01/19.
//  Copyright © 2019 Chaman Gurjar. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    
    @IBOutlet private weak var songImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var playPauseButton: UIButton!
    
    private var mediaPlayer = MPMusicPlayerController.applicationMusicPlayer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = mediaPlayer.nowPlayingItem {
            if let albumImage = item.artwork?.image(at: CGSize(width: 500, height: 500)) {
                songImageView.image = albumImage
            }
            if let albumTitle = item.title {
                titleLabel.text = albumTitle
            }
        }
        
        handlePlayPauseButtonTitle()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func chooseSongAction(_ sender: UIButton) {
        let mediaPickerVC = MPMediaPickerController(mediaTypes: .music)
        mediaPickerVC.allowsPickingMultipleItems = false
        mediaPickerVC.popoverPresentationController?.sourceView = view
        mediaPickerVC.delegate = self
        present(mediaPickerVC, animated: true, completion: nil)
    }
    
    @IBAction func playRandomSong(_ sender: UIButton) {
        if let songs = MPMediaQuery.songs().items {
            let randomIndex = arc4random_uniform(UInt32(songs.count - 1))
            let item = songs[Int(randomIndex)]
            playSongUsingMediaPlayer(item: item)
        }
    }
    
    private func playSongUsingMediaPlayer(item: MPMediaItem) {
        if let albumImage = item.artwork?.image(at: CGSize(width: 500, height: 500)) {
            songImageView.image = albumImage
        }
        if let albumTitle = item.title {
            titleLabel.text = albumTitle
        }
        mediaPlayer.setQueue(with: MPMediaItemCollection(items: [item]))
        mediaPlayer.play()
        handlePlayPauseButtonTitle()
    }
    
    @IBAction func playPauseSong(_ sender: UIButton) {
        if mediaPlayer.playbackState == .playing {
            mediaPlayer.pause()
            playPauseButton.setTitle("Play!", for: .normal)
        } else {
            mediaPlayer.play()
            playPauseButton.setTitle("Pause !", for: .normal)
        }
    }
    
    private func handlePlayPauseButtonTitle() {
        if mediaPlayer.playbackState == .playing {
            playPauseButton.setTitle("Pause!", for: .normal)
        } else {
            playPauseButton.setTitle("Play !", for: .normal)
        }
    }
    
}

//MARK: - MPMediaPickerControllerDelegate
extension ViewController: MPMediaPickerControllerDelegate {
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        mediaItemCollection.items.forEach { (item) in
            playSongUsingMediaPlayer(item: item)
        }
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
}

