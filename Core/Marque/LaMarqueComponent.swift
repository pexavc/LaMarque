//
//  MarqueComponent.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

#if os(macOS)
import Quartz
#endif

public struct LaMarqueComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<LaMarqueCenter, LaMarqueState> = .init()
    
    //iOS only
    @State var isShowPicker: Bool = false
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0.0) {
            
            
            if state.stage == .none || state.stage == .picking {
                Spacer()
            }
            
            
            switch state.stage {
            case .preparedExport:
                exporting
            case .preparingExport:
                Brand.Colors.marble.opacity(0.93).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                    
                    VStack {
                        GraniteText("encoding...",
                                    Brand.Colors.black,
                                    .title3,
                                    .bold,
                                    fontType: .menlo)
                    }
                    
                )
            case .sharing:
                sharing
            case .verify:
                verifying
            case .invalidMarque:
                VStack {
                    Brand.Colors.black.opacity(0.93).overlay(
                        GraniteText("not authentic",
                                    Brand.Colors.marble,
                                    .title3,
                                    .bold,
                                    fontType: .menlo)
                                    .padding(.top, Brand.Padding.medium)
                                    .padding(.bottom, Brand.Padding.medium)
                    ).frame(height: 48)
                    
                    verifying
                }
                    
            case .verified:
                VStack {
                    verified
                        .padding(.top, Brand.Padding.large)
                    verifying
                }
            case .collected:
                    
                VStack {
                    Brand.Colors.black.opacity(0.93).overlay(
                        GraniteText("collected",
                                    Brand.Colors.marble,
                                    .title3,
                                    .bold,
                                    fontType: .menlo)
                            .padding(.top, Brand.Padding.medium)
                            .padding(.bottom, Brand.Padding.medium)
                    ).frame(height: 48)
                    
                    verifying
                }
            case .alreadyCollected:
                    
                VStack {
                    Brand.Colors.black.opacity(0.93).overlay(
                        GraniteText("already collected",
                                    Brand.Colors.marble,
                                    .title3,
                                    .bold,
                                    fontType: .menlo)
                            .padding(.top, Brand.Padding.medium)
                            .padding(.bottom, Brand.Padding.medium)
                    ).frame(height: 48)
                    
                    verifying
                }
                
            case .alreadyExists:
                VStack {
                    Brand.Colors.black.opacity(0.93).overlay(
                        GraniteText("already exists",
                                    Brand.Colors.marble,
                                    .title3,
                                    .bold,
                                    fontType: .menlo)
                            .padding(.top, Brand.Padding.medium)
                            .padding(.bottom, Brand.Padding.medium)
                    ).frame(height: 48)
                    
                    Spacer()
                }.onTapGesture {
                    set(\.stage, value: .none)
                }
                
            case .generating:
                Brand.Colors.marble.opacity(0.93).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                    
                        VStack {
                            Spacer()
                            
                            GraniteText("encoding...",
                                        Brand.Colors.black,
                                        .title3,
                                        .bold,
                                        fontType: .menlo)
                                .padding(.top, Brand.Padding.medium)
                                .padding(.bottom, Brand.Padding.medium)
                            Spacer()
                        }
                )
                
            default:
                if state.stage.hasPicked {
                    metadata
                }
                
//                if state.stage.isPicking {
//                    #if os(iOS)
////                    ImagePicker(image: _state.data.iosPickedImage, { path in
////                        marque(path)
////                    }, didCancel: {
////                        set(\.stage, value: .none)
////
////                    })
//                    #else
//                    GraniteAction(command, { openPicker() })
//                    #endif
//                }
                
                
                GraniteButtonComponent(state:
                                        .init(.addNoSeperator,
                                              colors: [Brand.Colors.yellow, Brand.Colors.purple],
                                              action:
                                                {
                                                    GraniteHaptic.light.invoke()
                                                    
                                                    sendEvent(LaMarqueEvents.AudioTest())
                                                    //Dev:
//                                                    set(\.stage, value: .picking)
//
//                                                    openPicker()
                                                })).sheet(isPresented: $isShowPicker) {
                                                    #if os(iOS)
                                                    ImagePicker(image: _state.data.iosPickedImage) { path in
                                                        marque(path)
                                                    }
                                                    #endif
                                                }
            }
        }
    }
    
    func marque(_ path: String) {
        var finalPath: String = path
        
        #if os(iOS)
        finalPath = UIImage.iosImagePathURL?.appendingPathComponent(path).path ?? path
        #endif
        
        
        set(\.data, value: .init(path: finalPath))
        
        switch state.stage {
        case .verify, .verified, .invalidMarque:
            sendEvent(LaMarqueEvents.Decoding.init(path: finalPath))
        default:
            set(\.stage, value: .metadata)
        }
        
        GraniteLogger.info("got path: \(finalPath)", .component, focus: true)
    }
}

extension LaMarqueComponent {
    
    var verified: some View {
        ZStack {
            VStack(spacing: Brand.Padding.xSmall) {
                
                GraniteText((state.verification?.creativeName ?? ""),
                            Brand.Colors.marble,
                            .title,
                            .bold,
                            .leading)
                
                GraniteText("by "+(state.verification?.creativeAuthor ?? ""),
                            Brand.Colors.marble,
                            .headline,
                            .italic,
                            .leading)
                
                GraniteText("hash: "+(state.verification?.hash ?? ""),
                            Brand.Colors.marble,
                            .footnote,
                            .regular,
                            .leading,
                            fontType: .menlo)
                            .padding(.top, Brand.Padding.small)
                
                GraniteText("exhibition id: "+(state.verification?.exhibitionId ?? ""),
                            Brand.Colors.marble,
                            .caption,
                            .regular,
                            .leading,
                            fontType: .menlo)
                
                
                GraniteButtonComponent(state: .init("collect",
                                textColor: Brand.Colors.white,
                                colors: [Brand.Colors.yellow, Brand.Colors.purple],
                                padding: .init(Brand.Padding.medium,
                                               Brand.Padding.small,
                                               Brand.Padding.medium,
                                               Brand.Padding.small),
                                action: {
                                    GraniteHaptic.light.invoke()
                                    sendEvent(LaMarqueEvents.Collect())
                                }))
            }
            .padding(.all, Brand.Padding.medium)
            .background(state.stage.isSharing ? Brand.Colors.black.opacity(0.93) : .clear)
            .border(Brand.Colors.marble, width: 2)
            .animation(.default)
            .frame(maxWidth: 300)
        }
    }
    
    var verifying: some View {
        ZStack {
            VStack {
                Spacer()
                
                VStack(spacing: Brand.Padding.xSmall) {
                    
                    GraniteButtonComponent(state: .init("verify",
                                                        textColor: Brand.Colors.greyV2,
                                                        colors: [Brand.Colors.black,
                                                                 Brand.Colors.marble.opacity(0.24)],
                                                        shadow: Brand.Colors.marble.opacity(0.57),
                                                        padding: .init(Brand.Padding.medium,
                                                                       Brand.Padding.small,
                                                                       Brand.Padding.medium,
                                                                       Brand.Padding.small),
                                                        action: {
                                                            GraniteHaptic.light.invoke()
                                                            openPicker()
                                                        }))
                }
                .padding(.all, Brand.Padding.medium)
                .background(Brand.Colors.black.opacity(0.93))
                .border(Brand.Colors.marble, width: 2)
                .animation(.default)
                
                Spacer()
            }
            .frame(maxWidth: 160, maxHeight: .infinity)
            .padding(.bottom, Brand.Padding.medium)
        }.sheet(isPresented: $isShowPicker) {
            #if os(iOS)
            ImagePicker(image: _state.data.iosPickedImage) { path in
                marque(path)
            }
            #endif
        }
    }
    
    var exporting: some View {
        ZStack {
            Color.black.opacity(0.75).onTapGesture {
                set(\.stage, value: .none)
            }
            
            #if os(macOS)
            Image(nsImage: state.sharing?.sharingImage ?? .init())
                .resizable()
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
                .scaledToFit()
            
            #else
            Image(uiImage: state.sharing?.sharingImage ?? .init())
                .resizable()
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
                .scaledToFit()
            #endif
            
            VStack {
                Spacer()
                
                VStack(spacing: Brand.Padding.xSmall) {
                    
                    GraniteText("< back", Brand.Colors.marble, .subheadline, .bold, .leading)
                        .modifier(TapAndLongPressModifier.init(tapAction: {
                            GraniteHaptic.light.invoke()
                            
                            set(\.stage, value: .none)
                            
                        }))
                        .padding(.leading, Brand.Padding.xSmall)
                        .padding(.bottom, Brand.Padding.medium9)
                    
                    GraniteButtonComponent(state: .init("export",
                                                        textColor: Brand.Colors.white,
                                                        colors: [Brand.Colors.yellow, Brand.Colors.purple],
                                                        padding: .init(Brand.Padding.medium,
                                                                       Brand.Padding.small,
                                                                       Brand.Padding.medium,
                                                                       Brand.Padding.small),
                                                        action: {
                                                            GraniteHaptic.light.invoke()
                                                            set(\.shouldExport, value: true)
                                                        })).fileExporter(isPresented: _state.shouldExport, document: MarqueDocument(image: state.encoding?.data ?? .init()), contentType: .png, onCompletion: { (result) in
                                                            if case .success = result {
                                                                GraniteLogger.info("exported from la-marque", .expedition, focus: true)
                                                            } else {
                                                                GraniteLogger.info("failed to export from la-marque", .expedition, focus: true)
                                                            }
                                                        })
                }
                .padding(.all, Brand.Padding.medium)
                .background(Brand.Colors.black.opacity(0.93))
                .border(Brand.Colors.marble, width: 2)
                .animation(.default)
            }
            .frame(maxWidth: 160, maxHeight: .infinity)
            .padding(.bottom, Brand.Padding.medium)
        }
    }
    
    var sharing: some View {
        ZStack {
            Color.black.opacity(0.75).onTapGesture {
                set(\.stage, value: .none)
            }
            
            #if os(macOS)
            Image(nsImage: state.sharing?.sharingImage ?? .init())
                .resizable()
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
                .scaledToFit()
            
            #else
            Image(uiImage: state.sharing?.sharingImage ?? .init())
                .resizable()
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
                .scaledToFit()
            #endif
            
            
            
            VStack {
                Spacer()
                
                VStack(spacing: Brand.Padding.xSmall) {
                    
                    GraniteText("< back", Brand.Colors.marble, .subheadline, .bold, .leading)
                        .modifier(TapAndLongPressModifier.init(tapAction: {
                            GraniteHaptic.light.invoke()
                            
                            set(\.stage, value: .none)
                            
                        }))
                        .padding(.leading, Brand.Padding.xSmall)
                        .padding(.bottom, Brand.Padding.medium9)
                    
                    GraniteText("hash: "+(state.sharing?.ipfsHash ?? ""),
                                Brand.Colors.marble,
                                .footnote,
                                .bold,
                                .leading, fontType: .menlo)
                    
                    if state.sharing?.isCollected == true {
                        GraniteText("exhibition id: "+(state.sharing?.ipfsHash ?? ""),
                                    Brand.Colors.marble,
                                    .caption,
                                    .regular,
                                    .leading,
                                    fontType: .menlo)
                    } else {
                        GraniteText("url: "+(state.sharing?.creativePath ?? ""),
                                    Brand.Colors.marble,
                                    .caption,
                                    .regular,
                                    .leading,
                                    fontType: .menlo)
                                    .onTapGesture {
                                        #if !os(macOS)
                                        GraniteHaptic.light.invoke()
                                        set(\.shouldShareURL, value: true)
                                        #endif
                                    }
                                    .sheet(isPresented: _state.shouldShareURL) {
                                        #if !os(macOS)
                                        if let path = state.sharing?.creativePath {
                                            ShareSheet(activityItems: [path])
                                        }
                                        #endif
                                    }
                    }
                    
//                    GraniteButtonComponent(state: .init("encode",
//                                                        textColor: Brand.Colors.white,
//                                                        colors: [Brand.Colors.yellow, Brand.Colors.purple],
//                                                        padding: .init(Brand.Padding.medium,
//                                                                       Brand.Padding.small,
//                                                                       Brand.Padding.medium,
//                                                                       Brand.Padding.small),
//                                                        action: {
//                                                            GraniteHaptic.light.invoke()
//                                                            sendEvent(LaMarqueEvents.Export())
//                                                        }))
                    
                    #if os(macOS)
                    shareButton.fileExporter(isPresented: _state.shouldExport,
                                             document: MarqueDocument(image: state.sharing?.originalImage ?? .init()),
                                             contentType: .png,
                                             onCompletion: { (result) in
                        if case .success = result {
                            GraniteLogger.info("exported from la-marque", .expedition, focus: true)
                        } else {
                            GraniteLogger.info("failed to export from la-marque", .expedition, focus: true)
                        }
                    })
                    #else
                    shareButton.sheet(isPresented: _state.shouldExport) {
                        if let image = state.sharing?.sharingURL {
                            ShareSheet(activityItems: [image])
                        }
                    }
                    #endif
                    
                        
                    
                        
                        
                }
                .padding(.all, Brand.Padding.medium)
                .background(state.stage.isSharing ? Brand.Colors.black.opacity(0.93) : .clear)
                .border(Brand.Colors.marble, width: 2)
                .animation(.default)
            }
            .frame(maxWidth: 300, maxHeight: .infinity)
            .padding(.bottom, Brand.Padding.large)
        }
    }
    
    var shareButton: some View {
        GraniteButtonComponent(state: .init("share",
                                            textColor: Brand.Colors.white,
                                            colors: [Brand.Colors.yellow, Brand.Colors.purple],
                                            padding: .init(Brand.Padding.medium,
                                                           Brand.Padding.small,
                                                           Brand.Padding.medium,
                                                           Brand.Padding.small),
                                            action: {
                                                GraniteHaptic.light.invoke()
                                                set(\.shouldExport, value: true)
                                            }))
    }
}
extension LaMarqueComponent {
    var metadata: some View {
        ZStack {
            Color.black.opacity(0.75).onTapGesture {
                set(\.stage, value: .none)
            }
            
            #if os(macOS)
            Image(nsImage: state.data.image)
                .resizable()
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
                .scaledToFit()
            
            #else
            Image(uiImage: state.data.image)
                .resizable()
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
                .scaledToFit()
            #endif
            
            VStack {
                Spacer()
                
                VStack {
                    
                    GraniteText("< back", Brand.Colors.marble, .subheadline, .bold, .leading)
                        .modifier(TapAndLongPressModifier.init(tapAction: {
                            GraniteHaptic.light.invoke()
                            
                            set(\.stage, value: .none)
                            
                        }))
                        .padding(.bottom, Brand.Padding.medium)
                        .padding(.leading, Brand.Padding.xSmall)
                    
                    HStack {
                        
                        #if os(macOS)
                        TextField("name of your piece",
                                  text: _state.data.name)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(Fonts.live(.headline, .bold))
                            .foregroundColor(Brand.Colors.black)
                            .padding(.leading, Brand.Padding.small)
                            .padding(.trailing, Brand.Padding.small)
                            .padding(.top, Brand.Padding.small)
                            .padding(.bottom, Brand.Padding.small)
                            .background(Brand.Colors.marble)
                        
                        #else
                        TextField("name of your piece",
                                  text: _state.data.name)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(Fonts.live(.headline, .bold))
                            .foregroundColor(Brand.Colors.black)
                            .padding(.leading, Brand.Padding.small)
                            .padding(.trailing, Brand.Padding.small)
                            .padding(.top, Brand.Padding.small)
                            .padding(.bottom, Brand.Padding.small)
                            .background(Brand.Colors.marble)
                            .keyboardObserving(offset: 142)
                        #endif
                        
                        
                    }
                    .frame(height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, Brand.Padding.medium9)
                    
                    GraniteButtonComponent(state: .init("curate",
                                                        textColor: Brand.Colors.white,
                                                        colors: [Brand.Colors.yellow, Brand.Colors.purple],
                                                        padding: .init(Brand.Padding.medium,
                                                                       Brand.Padding.small,
                                                                       Brand.Padding.medium,
                                                                       Brand.Padding.small),
                                                        action: {
                                                            GraniteHaptic.light.invoke()
                                                            sendEvent(LaMarqueEvents.Generate())
                                                        }))
                }
                .padding(.all, Brand.Padding.medium)
                .background(Brand.Colors.black.opacity(0.93))
                .border(Brand.Colors.marble, width: 2)
            }
            .frame(maxWidth: 300, maxHeight: .infinity)
            .padding(.bottom, Brand.Padding.medium)
        }
    }
}

extension LaMarqueComponent {
    #if os(macOS)
    
    func openPicker() {
        let openPanel = NSOpenPanel()
        openPanel.prompt = "Select File"
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["png","jpg","jpeg"]
        openPanel.begin { (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                guard let path = openPanel.url?.path else {
                    return
                }
                
                marque(path)
            }
        }
    }
    
    #else
    
    func openPicker() {
        self.isShowPicker = !self.isShowPicker
    }
    #endif
}

#if os(iOS)
struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}

struct ImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode)
    var presentationMode

    @Binding var image: GraniteImage?
    var completion: ((String) -> Void)?
    var didCancel: (() -> Void)?
    
    init(image: Binding<GraniteImage?>, _ completion: ((String) -> Void)? = nil, didCancel: (() -> Void)? = nil) {
        _image = image
        self.completion = completion
        self.didCancel = didCancel
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding var presentationMode: PresentationMode
        @Binding var image: GraniteImage?
        
        var completion: ((String) -> Void)?
        var didCancel: (() -> Void)?

        init(presentationMode: Binding<PresentationMode>, image: Binding<GraniteImage?>, _ completion: ((String) -> Void)? = nil, didCancel: (() -> Void)? = nil) {
            _presentationMode = presentationMode
            _image = image
            self.completion = completion
            self.didCancel = didCancel
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? GraniteImage else { return }
            image = uiImage
            
            let fileName = "la-marque"
            guard let fileURL = UIImage.iosImagePathURL?.appendingPathComponent(fileName) else { return }
            if let imageData = image?.pngData() {
                try? imageData.write(to: fileURL, options: .atomic)
                
                completion?(fileName)
            }
            
//            if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
//                let imgName = imgUrl.lastPathComponent
//                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
//                guard let localPath = documentDirectory?.appending(imgName) else { return }
//
//                let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//
//                guard let data = image.pngData() else { return }
//                (data as NSData).write(toFile: localPath, atomically: true)
//
//                //let photoURL = URL.init(fileURLWithPath: localPath)
//
//                completion?(fileName)
//            }
            
            presentationMode.dismiss()

        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
            didCancel?()
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image, completion, didCancel: didCancel)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
}

extension UIImage {
    static var iosImagePath: String? {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    }
    
    static var iosImagePathURL: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}


/**
 
 Example:
 struct ContentView: View {
 @State private var showShareSheet = false
 
 var body: some View {
 VStack(spacing: 20) {
 Text("Hello World")
 Button(action: {
 self.showShareSheet = true
 }) {
 Text("Share Me").bold()
 }
 }
 .sheet(isPresented: $showShareSheet) {
 ShareSheet(activityItems: ["Hello World"])
 }
 }
 }
 
 */
#elseif os(macOS)

#endif
