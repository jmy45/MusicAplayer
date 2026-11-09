//
//  PlayerViewModel.swift
//  SwiftAudio
//
//  Created by David Chavez on 4/12/24.
//

import SwiftAudioEx

#if os(macOS)
import AppKit
public typealias NativeImage = NSImage
#elseif os(iOS)
import UIKit
public typealias NativeImage = UIImage
#endif

extension PlayerView {
    
    final class ViewModel: ObservableObject,@unchecked Sendable {
        static let shared = ViewModel()
        // MARK: - Observables

        @Published var playing: Bool = false
        @Published var position: Double = 0
        @Published var artwork: NativeImage? = nil
        @Published var title: String = ""
        @Published var albumTitle: String = ""
        @Published var artist: String = ""
        @Published var maxTime: TimeInterval = 100
        @Published var isScrubbing: Bool = false
        @Published var elapsedTime: String = "00:00"
        @Published var remainingTime: String = "00:00"

        @Published var playWhenReady: Bool = false
        @Published var playbackState: AudioPlayerState = .idle

        // MARK: - Properties

        let controller = AudioController.shared

        // MARK: - Initializer

        init() {
            controller.player.event.playWhenReadyChange.addListener(self, handlePlayWhenReadyChange)
            controller.player.event.stateChange.addListener(self, handleAudioPlayerStateChange)
            controller.player.event.playbackEnd.addListener(self, handleAudioPlayerPlaybackEnd(data:))
            controller.player.event.secondElapse.addListener(self, handleAudioPlayerSecondElapsed)
            controller.player.event.seek.addListener(self, handleAudioPlayerDidSeek)
            controller.player.event.updateDuration.addListener(self, handleAudioPlayerUpdateDuration)
            controller.player.event.didRecreateAVPlayer.addListener(self, handleAVPlayerRecreated)
        }

        // MARK: - Updates

        private func render() {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.playing = (self.controller.player.playerState == .playing)
                self.playbackState = self.controller.player.playerState
                self.playWhenReady = self.controller.player.playWhenReady
                self.position = self.controller.player.currentTime
                self.maxTime = self.controller.player.duration
                self.artist = self.controller.player.currentItem?.getArtist() ?? ""
                self.title = self.controller.player.currentItem?.getTitle() ?? ""
                self.albumTitle = self.controller.player.currentItem?.getAlbumTitle() ?? ""
                self.elapsedTime = self.controller.player.currentTime.secondsToString()
                self.remainingTime = (self.controller.player.duration - self.controller.player.currentTime).secondsToString()
                if let item = self.controller.player.currentItem as? DefaultAudioItem {
                    self.artwork = item.artwork
                } else {
                    self.artwork = nil
                }
            }
        }

        private func renderTimes() {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.position = self.controller.player.currentTime
                self.maxTime = self.controller.player.duration
                self.elapsedTime = self.controller.player.currentTime.secondsToString()
                self.remainingTime = (self.controller.player.duration - self.controller.player.currentTime).secondsToString()
                print(self.elapsedTime)
            }
        }

        // MARK: - AudioPlayer Event Handlers

        func handleAudioPlayerStateChange(data: AudioPlayer.StateChangeEventData) {
            print("state=\(data)")
            render()
        }

        func handlePlayWhenReadyChange(data: AudioPlayer.PlayWhenReadyChangeData) {
            print("playWhenReady=\(data)")
            render()
        }

        func handleAudioPlayerPlaybackEnd(data: AudioPlayer.PlaybackEndEventData) {
            print("playEndReason=\(data)")
        }

        func handleAudioPlayerSecondElapsed(data: AudioPlayer.SecondElapseEventData) {
            if !isScrubbing {
                renderTimes()
            }
        }

        func handleAudioPlayerDidSeek(data: AudioPlayer.SeekEventData) {
            // .. don't need this
        }

        func handleAudioPlayerUpdateDuration(data: AudioPlayer.UpdateDurationEventData) {
            if !isScrubbing {
                renderTimes()
            }
        }

        func handleAVPlayerRecreated() {
            // .. don't need this
        }
    }
}
