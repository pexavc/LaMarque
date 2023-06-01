//
//  AudioTestExpedition.swift
//  lamarque
//
//  Created by PEXAVC on 1/17/22.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine
import GlassKit
import AVFoundation
import AVKit

struct AudioTestExpedition: GraniteExpedition {
    typealias ExpeditionEvent = LaMarqueEvents.AudioTest
    typealias ExpeditionState = LaMarqueState
    
    func audioBufferToData(PCMBuffer: AVAudioPCMBuffer) -> Data {
        let channelCount = 1  // given PCMBuffer channel count is 1
        let channels = UnsafeBufferPointer(start: PCMBuffer.floatChannelData, count: channelCount)
        let data = Data(bytes: channels[0], count: Int(PCMBuffer.frameLength * PCMBuffer.format.streamDescription.pointee.mBytesPerFrame))

        return data
    }
    
    
    func dataToPCMBuffer(format: AVAudioFormat, data: Data) -> AVAudioPCMBuffer? {

        let streamDesc = format.streamDescription.pointee
        let frameCapacity = UInt32(data.count) / streamDesc.mBytesPerFrame
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCapacity) else { return nil }

        buffer.frameLength = buffer.frameCapacity
        let audioBuffer = buffer.audioBufferList.pointee.mBuffers

        data.withUnsafeBytes { (bufferPointer) in
            guard let addr = bufferPointer.baseAddress else { return }
            audioBuffer.mData?.copyMemory(from: addr, byteCount: Int(audioBuffer.mDataByteSize))
        }

        return buffer
    }
    
    var audioEngine: AVAudioEngine = AVAudioEngine()
    var audioFilePlayer: AVAudioPlayerNode = AVAudioPlayerNode()

    func playMusicFromBuffer(PCMBuffer: AVAudioPCMBuffer) {

        let mainMixer = audioEngine.mainMixerNode
        audioEngine.attach(audioFilePlayer)
        audioEngine.connect(audioFilePlayer, to:mainMixer, format: PCMBuffer.format)
        try? audioEngine.start()
        audioFilePlayer.play()
        audioFilePlayer.scheduleBuffer(PCMBuffer, at: nil, options:AVAudioPlayerNodeBufferOptions.loops)
    }
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let url = Bundle.main.url(forResource: "Glass", withExtension: "m4a") else {
           print("url not found")
           return
        }
        
        guard let audioFile = try? AVAudioFile(forReading: url) else {
            return
        }

        //extract information

        var audioFileFormat = audioFile.fileFormat

        var audioFilePFormat = audioFile.processingFormat

        var audioFileLength = audioFile.length

        var audioFrameCount = UInt32(audioFile.length)

        var audioFileChannels = audioFile.fileFormat.channelCount

        var audioFileSamplingRate = audioFile.fileFormat.sampleRate

        // insert into buffer

        guard let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFilePFormat, frameCapacity: AVAudioFrameCount(audioFileLength)) else {
            print("no buffer")
            return
        }

        do {
            print(AVAudioFrameCount(audioFileLength))
            try audioFile.read(into: audioBuffer, frameCount: AVAudioFrameCount(audioFileLength))
        } catch let error {
            print(error.localizedDescription)
        }
        
        
        let data3 = audioBufferToData(PCMBuffer: audioBuffer)
        
        let openPanel = NSOpenPanel()
        openPanel.prompt = "Select"
        openPanel.allowsMultipleSelection = true
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = true
        
        playMusicFromBuffer(PCMBuffer: audioBuffer)
//        openPanel.begin { (result) -> Void in
//            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
//                guard let url = openPanel.url else {
//                    return
//                }
//
//                do {
//                    print(audioFile.fileFormat.commonFormat)
//                    let audioFile = try AVAudioFile(forWriting: url.appendingPathComponent("test.m4a"), settings: [AVFormatIDKey: kAudioFormatMPEG4AAC], commonFormat: audioFile.fileFormat.commonFormat, interleaved: false)
//
//                    if let buffer = dataToPCMBuffer(format: audioFilePFormat, data: data3) {
//                        print("let's write \(url.appendingPathComponent("test.m4a"))")
//                        try audioFile.write(from: audioBuffer)
//                    } else {
//                        print("nil buffer")
//                    }
//                } catch let error {
//                    print(error.localizedDescription)
//                }
//
//            }
//        }
        
        return
        
        print(data3.count)
        
        AudioContext.load(fromAudioURL: url) { context in
            guard context != nil else {
                print("audio context failed to load")
                return
            }
            
            
            guard let data = GlassEngine.Utilities.getAudioSamplesInt32(asset: context!.asset, 44100, sampleCount: context!.totalSamples) else {
                return
            }
            
            guard let data2 = GlassEngine.Utilities.getAudioSamples(asset: context!.asset, 44100, sampleCount: context!.totalSamples) else {
                return
            }
            
            // [CAN REMOVE] Testing audio encryption in MarqueKit
//            let kit = MarqueKit.init()
//            kit.encodeAudio("hello world", withSamples: data) { result in
//                let myFileTypeString = String(AVFileType.m4a.rawValue)
//
//                let d = Data(bytes: data, count: data.count)
//
//                do {
//                    print(myFileTypeString)
//                    let player = try AVAudioPlayer(data: data3, fileTypeHint: myFileTypeString)
//                    player.prepareToPlay()
//                    player.play()
//                } catch let error {
//                    print(error.localizedDescription)
//                }
//
//
//
//
//
//                kit.search(d) { result2 in
//                    print(result2.payload)
//                }
//            }
        }
    }
}

/// Holds audio information used for building waveforms
final class AudioContext {
    
    /// The audio asset URL used to load the context
    public let audioURL: URL
    
    /// Total number of samples in loaded asset
    public let totalSamples: Int
    
    /// Loaded asset
    public let asset: AVAsset
    
    // Loaded assetTrack
    public let assetTrack: AVAssetTrack
    
    private init(audioURL: URL, totalSamples: Int, asset: AVAsset, assetTrack: AVAssetTrack) {
        self.audioURL = audioURL
        self.totalSamples = totalSamples
        self.asset = asset
        self.assetTrack = assetTrack
    }
    
    public static func load(fromAudioURL audioURL: URL, completionHandler: @escaping (_ audioContext: AudioContext?) -> ()) {
        let asset = AVURLAsset(url: audioURL, options: [AVURLAssetPreferPreciseDurationAndTimingKey: NSNumber(value: true as Bool)])
        
        guard let assetTrack = asset.tracks(withMediaType: AVMediaType.audio).first else {
            fatalError("Couldn't load AVAssetTrack")
        }
        
        asset.loadValuesAsynchronously(forKeys: ["duration"]) {
            var error: NSError?
            let status = asset.statusOfValue(forKey: "duration", error: &error)
            switch status {
            case .loaded:
                guard
                    let formatDescriptions = assetTrack.formatDescriptions as? [CMAudioFormatDescription],
                    let audioFormatDesc = formatDescriptions.first,
                    let asbd = CMAudioFormatDescriptionGetStreamBasicDescription(audioFormatDesc)
                    else { break }
                
                let totalSamples = Int((asbd.pointee.mSampleRate) * Float64(asset.duration.value) / Float64(asset.duration.timescale))
                let audioContext = AudioContext(audioURL: audioURL, totalSamples: totalSamples, asset: asset, assetTrack: assetTrack)
                completionHandler(audioContext)
                return
                
            case .failed, .cancelled, .loading, .unknown:
                print("Couldn't load asset: \(error?.localizedDescription ?? "Unknown error")")
            }
            
            completionHandler(nil)
        }
    }
}
