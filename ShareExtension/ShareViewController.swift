//
//  ShareViewController.swift
//  ShareiOS
//
//  Created by PEXAVC on 4/28/19.
//  Copyright © 2019 PEXAVC. All rights reserved.
//

import UIKit
import Social

public struct Const {
    public struct General {
        public static var groupName: String = "group.la.marque"
    }
}

class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let item = self.extensionContext?.inputItems[0] as? NSExtensionItem{
            for ele in item.attachments!{
                let itemProvider = ele as! NSItemProvider
                
                if itemProvider.hasItemConformingToTypeIdentifier("public.jpeg"){
                    NSLog("itemprovider: %@", itemProvider)
                    
                    itemProvider.loadItem(forTypeIdentifier: "public.jpeg", options: nil, completionHandler: { (item, error) in
                        
                        if let url = item as? URL{
                            let imgData = try! Data(contentsOf: url)
                            
                            let dict: [String : Any] = ["imgData" :  imgData]
                            let userDefault = UserDefaults(suiteName: Const.General.groupName)
                            if userDefault != nil {
                                userDefault!.set(dict, forKey: "imgViaShareiOS")
                                userDefault!.synchronize()
                            }
                            
                        }else if let img = item as? UIImage, let imgData = img.pngData(){
                            let dict: [String : Any] = ["imgData" :  imgData]
                            let userDefault = UserDefaults(suiteName: Const.General.groupName)
                            if userDefault != nil {
                                userDefault!.set(dict, forKey: "imgViaShareiOS")
                                userDefault!.synchronize()
                            }
                        }
                        
                        let _ = self.openURL(URL(string: "lamarque://la.marque?share")!)
                        
                        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                        
                    })
                } else if itemProvider.hasItemConformingToTypeIdentifier("public.png") {
                    NSLog("itemproviderPNG: %@", itemProvider)
                    
                    itemProvider.loadItem(forTypeIdentifier: "public.png", options: nil, completionHandler: { (item, error) in
                        
                        if let url = item as? URL{
                            let imgData = try! Data(contentsOf: url)
                            
                            
                            let dict: [String : Any] = ["imgData" :  imgData, "url": url.absoluteString]
                            let userDefault = UserDefaults(suiteName: Const.General.groupName)
                            if userDefault != nil {
                                userDefault!.set(dict, forKey: "imgViaShareiOS")
                                userDefault!.synchronize()
                            }
                            
                        }else if let img = item as? UIImage, let imgData = img.pngData(){
                            let dict: [String : Any] = ["imgData" :  imgData]
                            let userDefault = UserDefaults(suiteName: Const.General.groupName)
                            if userDefault != nil {
                                userDefault!.set(dict, forKey: "imgViaShareiOS")
                                userDefault!.synchronize()
                            }
                        }
                        
                        let _ = self.openURL(URL(string: "lamarque://la.marque?share")!)
                        
                        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                    })
                } else if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
                    NSLog("itemproviderPNG: %@", itemProvider)
                    
                    itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (item, error) in
                        
                        if let url = item as? URL{
                            
                            let dict: [String : Any] = ["url": url.absoluteString]
                            let userDefault = UserDefaults(suiteName: Const.General.groupName)
                            if userDefault != nil {
                                userDefault!.set(dict, forKey: "imgViaShareiOS")
                                userDefault!.synchronize()
                            }
                            
                        }
                        
                        let _ = self.openURL(URL(string: "lamarque://la.marque?share")!)
                        
                        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                    })
                }
            }
        }
    }
    

    
    @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
    
//    override func isContentValid() -> Bool {
//        // Do validation of contentText and/or NSExtensionContext attachments here
//        return true
//    }
//
//    override func didSelectPost() {
//        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
//
//        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
//    }
//
//    override func configurationItems() -> [Any]! {
//        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
//        return []
//    }

}
