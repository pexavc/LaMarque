//
//  MarqueSite.swift
//  marble (iOS)
//
//  Created by PEXAVC on 2/28/21.
//

import Foundation

struct MarqueSite {
    var header: String {
        """
        <!DOCTYPE html>
        <html>
          <head>
            <meta property="og:image" content="https://gateway.ipfs.io/ipfs/QmQt9J74g3daLLG12nTH4VpUMst3Y51uCcSYCgkWbyppSA"/>
            <meta name="viewport" content="width=device-width" >
            <meta name="description" content="explore \(exhibitionCurator)'s exhibition. A curator by nature, collecting some wonders & sharing on the chain. Some whom may find obscene, others who'll find unique. - Mark Twain... La Marque Twain">
            <meta name="keywords" content="blockchain, nft, ipfs, art, curation, marque">
            <meta content="text/html;charset=utf-8" http-equiv="Content-Type">
            <meta content="utf-8" http-equiv="encoding">

            <link rel="stylesheet" href="style.css">
            <title>\(exhibitionCurator)'s exhibition</title>

            <style>
              @import url('https://fonts.googleapis.com/css2?family=Courier+Prime:wght@400&display=swap');
              @import url('https://fonts.googleapis.com/css?family=Playfair+Display:400,400i,700,700i,900,900i');
              .containerToTHEContainerheh {
                width: 100%;
                text-align: center;
              }

              .container {
                display: flex;
                flex-wrap: wrap;
                justify-content: flex-start;
              }

              .header {
                width: 100%;
                text-align: center;
              }
              .title {
                font-family: 'Playfair Display', serif;
                font-weight: 500;
                font-size: 24px;
              }

              .subtitle{
                font-family: 'Courier Prime', serif;
                font-size: 12px;
              }

              .installation {
                border:2px solid #A19A8E;
                height: 420px;
                width: auto;
                position: relative;
              }

              .metadataInstallation {
                background-color: #121212;
                border:2px solid #A19A8E;

                bottom: 0px;
                left: 0px;

                position: absolute;

                padding-top: 2px;
                padding-left: 6px;
                padding-right: 6px;
              }

              .metadataInstallation p {
                margin: 0;
                padding: 0;
                text-align: left;
              }

              .metadataInstallation p:last-child {
                margin: 0;
                padding: 0;
                text-align: left;
                padding-bottom: 2px;
              }

              .metadataInstallationHash {
                background-color: #121212;
                border:2px solid #A19A8E;

                bottom: 0px;
                right: 0px;

                position: absolute;
                padding-top: 4px;
                padding-left: 4px;
                padding-right: 4px;
              }

              .metadataInstallationHash p {
                margin: 0;
                padding: 0;
                text-align: right;
              }

              .metadataInstallationHash p:last-child {
                margin: 0;
                padding: 0;
                text-align: right;
                /* padding-bottom: 4px; */
              }

              .installationName {
                font-family: 'Playfair Display', serif;
                font-weight: 700;
                font-size: 16px;
              }

              .installationAuthor {
                font-family: 'Playfair Display', serif;
                font-weight: 500;
                font-style: italic;
                font-size: 12px;
              }

              .installationHash {
                font-family: 'Courier Prime', serif;
                font-size: 12px;
              }

              .footer {
                  width: 100%;

                  font-family: 'Playfair Display', serif;
                  font-weight: 500;
                  font-style: italic;
                  font-size: 12px;
                  margin-left: 12px;
              }

              img {
              }

              html, body {
                margin:0;
                padding:0;
                width:100%;
                height:100%;
                overflow: auto;
                background: #000;
                color: #A19A8E;
              }
            </style>
          </head>
          <body>
                <div class="header">
                  <p class="title"> \(exhibitionCurator)'s exhibition </br> <span class="subtitle"> exhibition id: \(exhibitionId) </span> </p>
                </div>
                <div class="containerToTHEContainerheh">
                  <div class="container">
        """
    }
    
    var footer: String {
        """
                                
                  </div>
              </div>
              <div class="footer">
                  <p> curated with La Marque. </p>
              </div>
            </body>
          </html>
        """
    }
    
    func metadataInstallation(_ installation: Installation) -> String {
        """
        <div class="metadataInstallation">
            <p class="installationName"> \(installation.creativeName) </p>
            <p class="installationAuthor"> by \(installation.creativeAuthor) </p>
        </div>
        """
    }
    
    func metadataHash(_ installation: Installation) -> String {
        """
        <div class="metadataInstallationHash">
            <p class="installationHash"> \(installation.displayHash) </p>
        </div>
        """
    }
    
    func installationContainer(_ installation: Installation) -> String {
        """
        <div class="installation">
          <img src="\(installation.creativePath)" width="auto" height="100%" />
          \(metadataInstallation(installation))

          \(metadataHash(installation))
        </div>
        """
    }
    
    let exhibitionId: String
    let exhibitionCurator: String
    public init(exhibitionId: String, exhibitionCurator: String) {
        self.exhibitionId = exhibitionId
        self.exhibitionCurator = exhibitionCurator
    }
    
    public func generate(_ installations: [Installation]) -> String? {
        
        var images: String = ""
        for installation in installations {
            images+=installationContainer(installation)
        }
        
        let html = header+images+footer
        let filename = getDocumentsDirectory().appendingPathComponent("exhibition.html")

        do {
            try html.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            
            return filename.path
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
        
        return nil
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
