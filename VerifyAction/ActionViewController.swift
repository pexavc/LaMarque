//
//  ActionViewController.swift
//  VerifyAction
//
//  Created by PEXAVC on 4/5/21.
//

import UIKit
import MobileCoreServices
import SafariServices

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = .init(x: 0.0, y: 0.5)
        gradient.endPoint = .init(x: 1.0, y: 0.5)
        gradient.cornerRadius = 3.0
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}

class ActionViewController: UIViewController {
    public struct DecodedInstallation {
        let hash: String
        let exhibitionId: String
        let creativeAuthor: String
        let creativeName: String
        let creativeURL: String
        let creativeData: Data
        let isValid: Bool
        
        public init(_ parts: [String], data: Data) {
            let isNotValid = parts.count < 4 || parts.filter({ $0.isEmpty }).count > 0
            
            self.isValid = !isNotValid
            self.hash = isNotValid ? "" : String(parts[0])
            self.exhibitionId = isNotValid ? "" : String(parts[1])
            self.creativeAuthor = isNotValid ? "" : String(parts[2])
            self.creativeName = isNotValid ? "" : String(parts[3])
            self.creativeURL = isNotValid ? "" : (parts.count > 4 ? String(parts[4]) : "")
            self.creativeData = data
        }
    }

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var metadataContainer: UIView!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hashLabel: UILabel!
    @IBOutlet weak var exhibitionLabel: UILabel!
    @IBOutlet weak var authenticLabel: UILabel!
    @IBOutlet weak var visitButton: UIButton!
    
    
    var decoded: DecodedInstallation? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        visitButton.applyGradient(colours: [UIColor.init(hexString: "#FFCD00"), UIColor.init(hexString: "#EC6CFF")])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metadataContainer.layer.borderColor = UIColor.init(red: 161/255.0, green: 154/255.0, blue: 142/255.0, alpha: 1.0).cgColor
        metadataContainer.layer.borderWidth = 2.0
        
        titleLabel?.clipsToBounds = false
        titleLabel?.layer.masksToBounds = false
        
        visitButton.titleLabel?.layer.shadowColor = UIColor.init(hexString: "#121212").cgColor
        visitButton.titleLabel?.layer.shadowRadius = 2.0
        visitButton.titleLabel?.layer.shadowOpacity = 0.75
        visitButton.titleLabel?.layer.shadowOffset = CGSize(width: 1, height: 1)
        visitButton.titleLabel?.layer.masksToBounds = false
        visitButton.layer.masksToBounds = false
    
        // Get the item[s] we're handling from the extension context.
        
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
        var imageFound = false
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! {
                if provider.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
                    // This is an image. We'll load it, then place it in our image view.
                    weak var weakImageView = self.imageView
                    provider.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil, completionHandler: { (imageURL, error) in
                        OperationQueue.main.addOperation { [weak self] in
                            
                            do {
                                
                                if let url = imageURL as? URL {
                                    let data = try Data(contentsOf: url)
                                    guard
                                        let image = UIImage(data: data) else { return }
                                    weakImageView?.image = image
                                    
                                    //[CAN REMOVE]
//                                    self?.kit.search(image) { result in
//                                        let decoded = DecodedInstallation.init(result.parts, data: data)
//
//                                        DispatchQueue.main.async {
//
//                                            guard decoded.isValid else {
//                                                self?.titleLabel.isHidden = true
//                                                self?.creatorLabel.isHidden = true
//                                                self?.hashLabel.isHidden = true
//                                                self?.exhibitionLabel.isHidden = true
//                                                self?.visitButton.isHidden = true
//
//                                                self?.authenticLabel.isHidden = false
//                                                return
//                                            }
//                                            self?.titleLabel.text = decoded.creativeName
//                                            self?.creatorLabel.text = "by " + decoded.creativeAuthor
//                                            self?.hashLabel.text = "hash: " + decoded.hash
//                                            self?.exhibitionLabel.text = "exhibition id: " + decoded.exhibitionId
//                                            self?.decoded = decoded
//                                        }
//                                    }
                                }
                            } catch let error {
                                
                            }
                        }
                    })
                    
                    imageFound = true
                    break
                }
            }
            
            if (imageFound) {
                // We only handle one image, so stop looking for more.
                break
            }
        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    @IBAction func visit() {
        guard let url = decoded?.creativeURL else { return }
        let final = "https://gateway.ipfs.io/ipfs/" + (url.isEmpty ? (decoded?.hash ?? "") : url)
        guard let finalurl = URL(string: final) else { return }
        
        DispatchQueue.main.async {
            
            let config = SFSafariViewController.Configuration()
//            config.

            let vc = SFSafariViewController(url: finalurl, configuration: config)
            self.present(vc, animated: true)
            
        }
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (0, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
