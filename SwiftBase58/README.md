# Swift base58

This is a port of go-base58 https://github.com/jbenet/go-base58 to provide a native Swift implementation of base58 for SwiftMultihash (https://github.com/NeoTeo/SwiftMultihash)

## Installation

### Carthage
Add the following to the Cartfile at the root of your project:
```
github "NeoTeo/SwiftBase58"
```

Then run `carthage update`.

##### You will then need to add SwiftBase58.framework to your Xcode project:

- Select your target's General tab.

- Add the framework from the Carthage/Build/Mac directory in your project root,
 either by dropping the SwiftBase58.framework file directly onto the "Embedded Binaries" or by clicking the + and navigating to it.  
- In case of a code signing error, select the target's Build Settings tab make sure the "Code Signing Identity" is either a valid identity or "Don't Code Sign".
Additional dependencies SwiftGMP.framework and SwiftHex.framework will be fetched when running the carthage update.

For more information on how to install via Carthage see the [README][carthage-installation]

[carthage-installation]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application

## Usage
```Swift
import SwiftBase58

func encodeDecode() {
    let buffer: [uint8] = [255, 254, 253, 252]
    println("Buffer: \(buffer)")

    let encodedString = SwiftBase58.encode(buffer)
    println("Encoded string: \(encodedString)")

    let decodedBuffer = SwiftBase58.decode(encodedString)
    println("Decoded buffer: \(decodedBuffer)")
}
```

See also the example project [here](http://gateway.ipfs.io/ipfs/QmNWf1471uc7z7VcngpC5rwGLbfAxkvbHRRMuerzKiphkN)
## License
The SwiftBase58 (as the originating go-base58 and original btcutil before it) are licensed under the ISC License.
