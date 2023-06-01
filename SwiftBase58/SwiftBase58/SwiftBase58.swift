//
//  SwiftBase58.swift
//  SwiftBase58
//
//  Created by Teo on 19/05/15.
//  Copyright (c) 2015 Teo. All rights reserved.
//
//  Licensed under MIT See LICENCE file in the root of this project for details. 

import Foundation
import SwiftGMP

let BTCAlphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"


let bigRadix = GMPInteger(58)
let bigZero = GMPInteger(0)

public func decode(_ b: String) -> [UInt8] {
    return decodeAlphabet(b, alphabet: BTCAlphabet)
}

public func encode(_ b: [UInt8]) -> String {
    return encodeAlphabet(b, alphabet: BTCAlphabet)
}

func decodeAlphabet(_ b: String, alphabet: String) -> [UInt8] {
    var answer = GMPInteger(0)
    var j = GMPInteger(1)

    for ch in Array(b.reversed()) {
        // Find the index of the letter ch in the alphabet.
        if let charRange = alphabet.range(of: String(ch)) {
            let letterIndex = alphabet.distance(from: alphabet.startIndex, to: charRange.lowerBound)
            let idx = GMPInteger(letterIndex)
            var tmp1 = GMPInteger(0)
            
            tmp1 = .mul(j, idx)
            
            answer = .add(answer, tmp1)
            
            j = .mul(j, bigRadix)
        } else {
            
            return []
        }
    }


    /// Remove leading 1's
    // Find the first character that isn't 1
    let bArr = Array(b)
    let zChar = Array(alphabet).first
    var nz = 0
    
    for _ in 0 ..< b.count {
        if bArr[nz] != zChar { break }
        nz += 1
    }
    
    let tmpval = GMPInteger.bytes(answer)
    var val = [UInt8](repeating: 0, count: nz)
    val += tmpval
    return val

}


func encodeAlphabet(_ byteSlice: [UInt8], alphabet: String) -> String {
    var bytesAsIntBig = GMPInteger(byteSlice)
    let byteAlphabet = [UInt8](alphabet.utf8)
    
    var answer = [UInt8]()//(count: byteSlice.count*136/100, repeatedValue: 0)
    
    while GMPInteger.cmp(bytesAsIntBig, bigZero) > 0 {
        let mod = GMPInteger()
        let (quotient, modulus) = GMPInteger.divMod(bytesAsIntBig, bigRadix, mod)
        
        bytesAsIntBig = quotient
        
        // Make the String into an array of characters.
        answer.insert(byteAlphabet[GMPInteger.getInt64(modulus)!], at: 0)
    }
    
    // leading zero bytes
    for ch in byteSlice {
        if ch != 0 { break }
        answer.insert(byteAlphabet[0], at: 0)
    }
    
    return String(bytes: answer, encoding: String.Encoding.utf8)!
}
