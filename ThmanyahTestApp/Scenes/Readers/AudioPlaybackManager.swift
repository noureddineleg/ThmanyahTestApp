//
//  AudioPlaybackManager.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import AVFoundation
import SwiftUI
import Combine

/// Shared audio playback state for MiniPlayerBanner and AudioReaderView.
@MainActor
final class AudioPlaybackManager: ObservableObject {
    @Published var currentItem: ContentItem?
    @Published var isPlaying = false
    @Published var progress: Double = 0
    @Published var durationSeconds: Double = 0
    @Published var currentTimeLabel = "0:00"
    @Published var durationLabel = "0:00"

    private var player: AVPlayer?
    private var timeObserver: Any?

    func play(_ item: ContentItem) {
        guard item.audioURL != nil else { return }
        if currentItem?.id == item.id {
            player?.play()
            isPlaying = true
            return
        }
        cleanup()
        currentItem = item
        let p = AVPlayer(url: item.audioURL!)
        player = p
        durationLabel = item.duration ?? "0:00"
        progress = 0
        currentTimeLabel = "0:00"
        observeDuration(p)
        observePeriodicTime(p)
        p.play()
        isPlaying = true
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func togglePlayPause() {
        guard currentItem != nil else { return }
        if isPlaying {
            pause()
        } else {
            player?.play()
            isPlaying = true
        }
    }

    func skip(seconds: Int) {
        guard player != nil else { return }
        let target = max(0, min(progress + Double(seconds), durationSeconds))
        seek(to: target)
    }

    func seek(to progressValue: Double) {
        guard let player else { return }
        let sec = max(0, min(progressValue, durationSeconds))
        player.seek(to: CMTime(seconds: sec, preferredTimescale: 600))
        progress = sec
        currentTimeLabel = formatTime(sec)
    }

    func cleanup() {
        player?.pause()
        if let player, let timeObserver {
            player.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
        player = nil
        currentItem = nil
        isPlaying = false
        progress = 0
        durationSeconds = 0
        currentTimeLabel = "0:00"
        durationLabel = "0:00"
    }

    private func observeDuration(_ player: AVPlayer) {
        Task {
            guard let duration = try? await player.currentItem?.asset.load(.duration),
                  duration.seconds.isFinite else { return }
            await MainActor.run {
                durationSeconds = duration.seconds
                durationLabel = formatTime(duration.seconds)
            }
        }
    }

    private func observePeriodicTime(_ player: AVPlayer) {
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self else { return }
            let sec = time.seconds
            if sec.isFinite {
                self.progress = sec
                self.currentTimeLabel = self.formatTime(sec)
            }
        }
    }

    private func formatTime(_ seconds: Double) -> String {
        let s = Int(seconds)
        let m = s / 60
        let h = m / 60
        if h > 0 {
            return String(format: "%d:%02d:%02d", h, m % 60, s % 60)
        }
        return String(format: "%d:%02d", m, s % 60)
    }
}
