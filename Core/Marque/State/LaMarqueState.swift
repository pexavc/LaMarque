//
//  MarqueState.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine
import UniformTypeIdentifiers

public enum LaMarqueStage {
    case picking
    case metadata
    case generating
    case sharing
    case preparingExport
    case preparedExport
    case verify
    case verified
    case collected
    case invalidMarque
    case alreadyCollected
    case alreadyExists
    case decoding
    case none
    
    var isAdding: Bool {
        self == .picking || self == .metadata
    }
    
    var isSharing: Bool {
        self == .sharing
    }
    
    var isAddingMetadata: Bool {
        self == .metadata
    }
    
    var hasPicked: Bool {
        self == .metadata
    }
    
    var isPicking: Bool {
        self == .picking
    }
}

public class LaMarqueState: GraniteState {
    var stage: LaMarqueStage = .none
    
    var data: LaMarqueData = .init()
    var sharing: Installation? = nil
    
    var encoding: MarqueKitEncodeResult? = nil
    var shouldExport: Bool = false
    var shouldShareURL: Bool = false
    var shouldPick: Bool = false
    
    var verification: DecodedInstallation? = nil
    
    public init(_ sharing: Installation? = nil) {
        self.sharing = sharing
        
        if sharing != nil {
            stage = .sharing
        }
    }
    
    public init(_ stage: LaMarqueStage) {
        self.stage = stage
        self.shouldPick = stage.isPicking
        self.sharing = nil
    }
    
    required init() {
        self.sharing = nil
    }
}

public class LaMarqueCenter: GraniteCenter<LaMarqueState> {
    let relay: MarqueRelay = .init()
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GenerateLaMarqueExpedition.Discovery(),
            MarqueResultExpedition.Discovery(),
            ExportLaMarqueExpedition.Discovery(),
            EncodingLaMarqueExpedition.Discovery(),
            DecodingLaMarqueExpedition.Discovery(),
            DecodingResultLaMarqueExpedition.Discovery(),
            CollectMarqueExpedition.Discovery(),
            GenerateSiteMarqueExpedition.Discovery(),
            GenerateSiteResultMarqueExpedition.Discovery(),
            MarqueResultExistsExpedition.Discovery(),
            AudioTestExpedition.Discovery()
        ]
    }
    
    public override var behavior: GraniteEventBehavior {
        .broadcastable
    }
}

public struct LaMarqueVerify {
    let creativeName: String
    let creativeAuthor: String
    let hash: String
    let creativeData: Data
}

public struct LaMarqueData: Equatable {
    var path: String
    var name: String
    
    var iosPickedImage: GraniteImage? = .init()
    
    public init(path: String) {
        self.path = path
        self.name = ""
    }
    
    public init() {
        self.path = ""
        self.name = ""
    }
    
    public var isReady: Bool {
        path.isNotEmpty && name.isNotEmpty
    }
    
    public var image: GraniteImage {
        if let image =  GraniteImage(contentsOfFile: path) {
            GraniteLogger.info("image received: \(image.size)", .center, focus: true)
            return image
        } else {
            GraniteLogger.info("image is not valid", .center, focus: true)
            return .init()
        }
    }
    
    public var signature: String {
        let creativeID: String = Services.shared.localStorage.get(GlobalDefaults.ExhibitionID, defaultValue: "invalid id")
        let creativeName: String = Services.shared.localStorage.get(GlobalDefaults.ExhibitionName, defaultValue: "La Marque::\(Date.today.asString)")
        let creativeURL: String = Services.shared.localStorage.get(GlobalDefaults.ExhibitionSite, defaultValue: "invalid site")
        
        //[REPURPOSE]
        return "[REPURPOSE]"//MarqueKit.combine([creativeID, creativeName, name, creativeURL])
    }
}

#if os(macOS)
extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
#endif

struct MarqueDocument: FileDocument {
    static var readableContentTypes: [UTType] = [.png]
    
    // by default our document is empty
    var image: GraniteImage

    // a simple initializer that creates new, empty documents
    init(image: GraniteImage) {
        self.image = image
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents,
           let d = GraniteImage.init(data: data) {
            image = d
        } else {
            image = .init()
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = image.pngData() ?? .init()
        return FileWrapper(regularFileWithContents: data)
    }
    
}
