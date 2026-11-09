//
//  AudioController.swift
//  SwiftAudio_Example
//
//  Created by Jørgen Henrichsen on 25/03/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import SwiftAudioEx

final class AudioController:@unchecked Sendable {
    
    static let shared = AudioController()
    let player: QueuedAudioPlayer
    
    let sources: [AudioItem] = [
        DefaultAudioItem(audioUrl: "https://127.0.0.1:8443/MusicResources/b.mp3", artist: "Jay Chou", title: "Jiandanai", sourceType: .stream,artwork: #imageLiteral(resourceName: "22AMI")),
//        DefaultAudioItem(audioUrl: "https://rntp.dev/example/Longing.mp3", artist: "David Chavez", title: "Longing", sourceType: .stream, artwork: #imageLiteral(resourceName: "22AMI")),
    ]
    @MainActor
    func additem(audiourl: String,artist: String,title: String,albumTitle: String?,sourceType:SourceType = .stream,artworkimage: AudioItemImage?){
        let audioitem: AudioItem = DefaultAudioItem(audioUrl: audiourl, artist: artist,title: title, albumTitle: albumTitle, sourceType:sourceType, artwork: artworkimage)
        Task{
            if !player.items.contains(where: {$0.getSourceUrl() == audioitem.getSourceUrl()})
            {
                player.add(item:audioitem)
            }
        }
    }
    init() {
        let controller = RemoteCommandController()
        player = QueuedAudioPlayer(remoteCommandController: controller)
        player.remoteCommands = [
            .stop,
            .play,
            .pause,
            .togglePlayPause,
            .next,
            .previous,
            .changePlaybackPosition
        ]
       
        player.repeatMode = .queue
//        DispatchQueue.main.async {
//            self.player.add(items: self.sources)
//        }
    }
    
}
