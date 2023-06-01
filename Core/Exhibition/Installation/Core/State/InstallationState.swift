//
//  InstallationState.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine
import MarbleKit

public enum InstallationStage {
    case prepared
    case snapshot
    case none
    
    var isNotPrepared: Bool {
        self == .none
    }
    
    var isPrepared: Bool {
        !isNotPrepared
    }
    
    var isSnapshot: Bool {
        self == .snapshot
    }
}
public class InstallationState: GraniteState {
    
    var stage: InstallationStage = .none
    var installation: Installation
    let installations: [Installation]
    var showcaseIndex: Int = 0
    
    var viewingOriginal: Bool = false
    var viewingMarble: Bool = false
    var sharingMarble: Bool = false
    var isEditing: Bool = false
    
    
    var currentImage: GraniteImage {
        originalImage//viewingOriginal ? originalImage : (marbledImage ?? originalImage)
    }
    
    var marbledImage: GraniteImage? = nil
    var originalImage: GraniteImage = .init()
    let loader: ImageLoader
    
    var isShowcase: Bool
    
    public init(_ newInstallation: Installation, isShowcase: Bool = false) {
        self.installation = newInstallation
        self.installations = []
        self.isShowcase = isShowcase
        
        self.loader = .init()
//        if installation.isCollected {
        self.originalImage = installation.originalImage
//            self.loader = .init()
//        } else {
//            self.loader = ImageLoader(urlString: installation.creativePath)
//        }
    }
    
    public init(_ installations: [Installation], isShowcase: Bool = false) {
        self.installation = .empty
        self.installations = installations
        self.loader = .init()
        self.isShowcase = isShowcase
    }
    
    public required init() {
        installation = .empty
        installations = []
        loader = .init()
        self.isShowcase = false
    }
}

public class InstallationCenter: GraniteCenter<InstallationState> {
    @GraniteDependency
    var envDependency: EnvironmentDependency
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            PrepareInstallationExpedition.Discovery(),
            SnapshotInstallationExpedition.Discovery(),
            ViewMarbleInstallationExpedition.Discovery(),
            ShowcaseInstallationExpedition.Discovery(),
        ]
    }
    
    public override var links: [GraniteLink] {
        [
            .onAppear(InstallationEvents.Prepare(), .dependant)
        ]
    }
    
    public override var behavior: GraniteEventBehavior {
        .passthrough
    }
}

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString: String = "") {
        guard let url = URL(string: urlString), urlString.isNotEmpty else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}
