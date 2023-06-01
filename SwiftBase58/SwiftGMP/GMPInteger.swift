//
//  GMPInteger.swift
//  SwiftGMP
//
//  Created by Teo Sartori on 27/08/16.
//  Copyright © 2016 Teo. All rights reserved.
//

import Foundation
import GMP

public class GMPInteger {
    var i: mpz_t
    var inited: Bool
    
    public init() {
        i = mpz_t()
        __gmpz_init(&i)
        inited = true
    }
    
    public convenience init(_ x: Int) {
        self.init()
        
        let y = CLong(x)
        if Int(y) == x {
            __gmpz_set_si(&i, y)
        } else {
            var negative = false
            var nx = x
            if x < 0 {
                nx = -x
                negative = true
            }
            
            __gmpz_import(&i, 1, 0, 8, 0, 0, &nx)
            if negative {
                __gmpz_neg(&i, &i)
            }
        }
        
    }
    
    public convenience init(_ buffer: [UInt8]) {
        self.init(0)
        var b = buffer
        if buffer.count != 0 {
            __gmpz_import(&i, size_t(buffer.count), 1, 1, 1, 0, &b)
        }
    }
    
    public convenience init(_ string: String) {
        self.init()
        __gmpz_set_str(&i,(string as NSString).utf8String, 10)
        
    }
    
    deinit {
        if self.inited {
            __gmpz_clear(&i)
        }
        self.inited = false
    }
}

extension GMPInteger {
    static func _Int_finalize(_ z: inout GMPInteger) {
        if z.inited {
            __gmpz_clear(&z.i)
        }
    }
    
    static func clear(_ z: inout GMPInteger) {
        _Int_finalize(&z)
    }
    
    static func sign(_ number: GMPInteger) -> Int {
        if number.i._mp_size < 0 {
            return -1
        } else {
            return Int(number.i._mp_size)
        }
    }
    
    // Int64
    public static func getInt64(_ number: GMPInteger) -> Int? {
        let oldGMPInteger = number
        
        if oldGMPInteger.inited == false { return nil }
        
        if __gmpz_fits_slong_p(&oldGMPInteger.i) != 0 {
            return Int(__gmpz_get_si(&oldGMPInteger.i))
        }
        // Undefined result if > 64 return nil
        if GMPInteger.bitLen(oldGMPInteger) > 64 { return nil }
        
        var newInt64 = Int()
        __gmpz_export(&newInt64, nil, -1, 8, 0, 0, &oldGMPInteger.i)
        if GMPInteger.sign(oldGMPInteger) < 0 {
            newInt64 = -newInt64
        }
        return newInt64
    }
    
    public static func abs(_ x: GMPInteger) -> GMPInteger {
        let a = x
        let c = GMPInteger() //self
        __gmpz_abs(&c.i, &a.i)
        return c
    }
    
    public static func neg(_ x: GMPInteger) -> GMPInteger {
        let a = x
        let c = GMPInteger() //self
        __gmpz_neg(&c.i, &a.i)
        return c
    }
    
    public static func add(_ x: GMPInteger, _ y: GMPInteger) -> GMPInteger {
        let a = x
        let b = y
        let c = GMPInteger() //self
        __gmpz_add(&c.i, &a.i, &b.i)
        return c
    }
    
    public static func sub(_ x: GMPInteger, _ y: GMPInteger) -> GMPInteger {
        let a = x
        let b = y
        let c = GMPInteger() //self
        __gmpz_sub(&c.i, &a.i, &b.i)
        return c
    }
    
    public static func mul(_ x: GMPInteger, _ y: GMPInteger) -> GMPInteger {
        let a = x
        let b = y
        let c = GMPInteger() //self
        __gmpz_mul(&c.i, &a.i, &b.i)
        return c
    }
    
    private static func inBase(_ number: GMPInteger, _ base: Int) -> String {
        var ti = number.i
        let p = __gmpz_get_str(nil, CInt(base), &ti)
        let s = String(cString: p!)
        return s
    }
    
    public static func string(_ number: GMPInteger) -> String {
        return self.inBase(number, 10)
    }
    
    public var description : String {
        return GMPInteger.string(self)
    }

    // DivMod sets z to the quotient x div y and m to the modulus x mod y
    // and returns the pair (z, m) for y != 0.
    // If y == 0, a division-by-zero run-time panic occurs.
    //
    // DivMod implements Euclidean division and modulus (unlike Go):
    //
    //	q = x div y  such that
    //	m = x - y*q  with 0 <= m < |q|
    //
    // (See Raymond T. Boute, ``The Euclidean definition of the functions
    // div and mod''. ACM Transactions on Programming Languages and
    // Systems (TOPLAS), 14(2):127-144, New York, NY, USA, 4/1992.
    // ACM press.)
    public static func divMod(_ x: GMPInteger, _ y: GMPInteger, _ m: GMPInteger) -> (GMPInteger, GMPInteger) {
        let xl = x
        let yl = y
        let ml = m
        let zl = GMPInteger() //self
        
        switch sign(yl) {
        case 1:
            __gmpz_fdiv_qr(&zl.i, &ml.i, &xl.i, &yl.i)
        case -1:
            __gmpz_cdiv_qr(&zl.i, &ml.i, &xl.i, &yl.i)
        default:
            fatalError("Division by zero")
        }
        return (zl, ml)
    }
    
    public static func div(_ x: GMPInteger, _ y: GMPInteger) -> GMPInteger {
        let xl = x
        let yl = y
        let zl = GMPInteger() //self
        
        switch sign(yl) {
        case 1:
            __gmpz_fdiv_q(&zl.i, &xl.i, &yl.i)
        case -1:
            __gmpz_cdiv_q(&zl.i, &xl.i, &yl.i)
        default:
            fatalError("Division by zero")
        }
        return zl
    }
    
    // Cmp compares x and y and returns:
    //
    //   -1 if x <  y
    //    0 if x == y
    //   +1 if x >  y
    public static func cmp(_ number: GMPInteger, _ y: GMPInteger) -> Int {
        let xl = number //self
        let yl = y
        var r = Int(__gmpz_cmp(&xl.i, &yl.i))
        if r < 0 {
            r = -1
        } else if r > 0 {
            r = 1
        }
        return r
    }
    
    public static func bytes(_ number: GMPInteger) -> [UInt8] {
        let num = number//self
        let size = 1 + ((bitLen(number) + 7) / 8)
        var b = [UInt8](repeating: UInt8(0), count: size)
        var n = size_t(b.count)
        __gmpz_export(&b, &n, 1, 1, 1, 0, &num.i)
        
        return Array(b[0..<n])
    }
    
    static func bitLen(_ number: GMPInteger) -> Int {
        let num = number
        if sign(number) == 0 {
            return 0
        }
        //    var c = self
        return Int(__gmpz_sizeinbase(&num.i, 2))
    }
}

extension GMPInteger : Equatable, Comparable {
    
    public static func + (_ a : GMPInteger, _ b : GMPInteger) -> GMPInteger {
        return GMPInteger.add(a, b)
    }
    
    public static func - (_ a : GMPInteger, _ b : GMPInteger) -> GMPInteger {
        return GMPInteger.sub(a, b)
    }

    public static func * (_ a : GMPInteger, _ b : GMPInteger) -> GMPInteger {
        return GMPInteger.mul(a, b)
    }

    public static func / (_ a : GMPInteger, _ b : GMPInteger) -> GMPInteger {
        return GMPInteger.div(a, b)
    }

    public static func == (_ a : GMPInteger, _ b : GMPInteger) -> Bool {
        return GMPInteger.cmp(a, b) == 0 ? true : false
    }
    
    public static func < (_ a : GMPInteger, _ b : GMPInteger) -> Bool {
        return GMPInteger.cmp(a, b) < 0 ? true : false
    }
    
}
