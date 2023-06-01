//
//  GMPDouble.swift
//  SwiftGMP
//
//  Created by twodayslate on 8/26/16.
//  Copyright © 2016 Teo. All rights reserved.
//

import Foundation
import GMP

// Multiple-precision Floating-point
public class GMPDouble {
    private var d : mpf_t
    private var inited : Bool = false;
    
    public init() {
        d = mpf_t()
        __gmpf_init(&d);
        inited = true
    }
    
    public init(precision : Int) {
        d = mpf_t()
        __gmpf_init2(&d, mp_bitcnt_t(precision));
        inited = true
    }
    
    public convenience init(_ x : Double, precision : Int) {
        self.init(precision : precision)
        let y = CDouble(x)
        if Double(y) == x {
            __gmpf_set_d(&d, y)
        } else {
            // something went wrong
        }
    }
    
    public init(_ x : Double) {
        //self.init(x, precision: GMPDouble.defaultPrecision)
        let y = CDouble(x)
        self.d = mpf_t()
        if Double(y) == x {
            __gmpf_init_set_d(&d, y)
            self.inited = true
        } else {
            // something went wrong
        }
    }
    
    public convenience init(_ str : String, base : Int, precision : Int) {
        self.init(precision : precision)
        __gmpf_set_str(&d, (str as NSString).utf8String, 10)
    }
    
    public convenience init(_ str : String, precision : Int) {
        self.init(str, base: 10, precision: precision)
    }
    
    public init(_ str : String, base : Int) {
        self.d = mpf_t()
        __gmpf_init_set_str(&d, (str as NSString).utf8String, CInt(base))
        self.inited = true
    }
    
    public convenience required init(_ str : String) {
        self.init(str, base : 10)
    }
    
    deinit {
        if(self.inited) {
            __gmpf_clear(&d)
            self.inited = false
        }
    }
    
    public static var defaultPrecision : Int {
        get {
            return Int(__gmpf_get_default_prec())
        }
        set (newDefaultPrec) {
            __gmpf_set_default_prec(mp_bitcnt_t(newDefaultPrec))
        }
    }
    
    public var precision : Int {
        get {
           return Int(__gmpf_get_prec(&d))
        }
        set (newPrec) {
            __gmpf_set_prec(&d, mp_bitcnt_t(newPrec))
        }
    }
    
    // Return non-zero if an integer.
    public func isInteger() -> Int32 {
        var x = d
        return __gmpf_integer_p(&x)
    }

    public static func add(_ a : GMPDouble, _ b : GMPDouble) -> GMPDouble {
        let x = a, y = b;
        let c = GMPDouble(precision : x.precision)
        __gmpf_add(&c.d, &x.d, &y.d)
        return c
    }

    public static func sub(_ a: GMPDouble, _ b: GMPDouble) -> GMPDouble {
        let x = a, y = b;
        let c = GMPDouble(precision : x.precision) //self
        __gmpf_sub(&c.d, &x.d, &y.d)
        return c
    }

    public static func mul(_ x: GMPDouble, _ y: GMPDouble) -> GMPDouble {
        let a = x
        let b = y
        let c = GMPDouble(precision : x.precision) //self
        __gmpf_mul(&c.d, &a.d, &b.d)
        return c
    }

    public static func div(_ x: GMPDouble, _ y: GMPDouble) -> GMPDouble {
        let a = x
        let b = y
        let c = GMPDouble(precision : x.precision) //self
        __gmpf_div(&c.d, &a.d, &b.d)
        return c
    }
    
    public static func abs(_ x: GMPDouble) -> GMPDouble {
        let a = x
        let b = GMPDouble(precision : x.precision)
        __gmpf_abs(&b.d, &a.d)
        return b
    }
    
    public static func sqrt(_ x: GMPDouble) -> GMPDouble {
        let a = x
        let b = GMPDouble(precision : x.precision)
        __gmpf_sqrt(&b.d, &a.d)
        return b
    }
    
    public static func pow(_ x: GMPDouble, _ pow : Int) -> GMPDouble {
        let a = x
        let b = GMPDouble(precision : x.precision)
        __gmpf_pow_ui(&b.d, &a.d, UInt(pow))
        return b
    }
    
    public static func neg(_ x: GMPDouble) -> GMPDouble {
        let a = x
        let b = GMPDouble(precision : x.precision)
        __gmpf_neg(&b.d, &a.d)
        return b
    }

    public static func floor(_ x: GMPDouble) -> GMPDouble {
        let a = x
        let b = GMPDouble(precision : x.precision)
        __gmpf_floor(&b.d, &a.d)
        return b
    }

    public static func ceil(_ x: GMPDouble) -> GMPDouble {
        let a = x
        let b = GMPDouble(precision : x.precision)
        __gmpf_ceil(&b.d, &a.d)
        return b
    }
    
    public static func trun(_ x : GMPDouble) -> GMPDouble {
        let a = x
        let b = GMPDouble(precision : x.precision)
        __gmpf_trunc(&b.d, &a.d)
        return b
    }

    // Cmp compares x and y and returns:
    //
    //   -1 if x <  y
    //    0 if x == y
    //   +1 if x >  y
    public static func cmp(_ number: GMPDouble, _ y: GMPDouble) -> Int {
        let xl = number
        let yl = y
        return Int(__gmpf_cmp(&xl.d, &yl.d))
    }

    /**
     * Convert `number` to a string of digits in base `base`. Trailing zeros are not returned. 
     * No more digits than can be accurately represented by number are ever generated.
     *
     * For example, the number 3.1416 would be returned as string "31416" and exponent 1.
     *
     * - parameter number: The number to be converted
     * - parameter base: The base to convert to. The base argument may vary from 2 to 62 or from -2 to -36.
     *
     *   For `base` in the range 2..36, digits and lower-case letters are used; 
     *   for -2..-36, digits and upper-case letters are used; for 37..62, digits, 
     *   upper-case letters, and lower-case letters (in that significance order) are used.
     *
     * - returns: `(string : String?, exponent : Int)` 
     *             A tuple with a string representation and an exponent
     *
     *   When `number` is zero, an empty string is produced and the exponent returned is 0.
     */
    public static func strBase(_ number: GMPDouble, _ base: Int) -> (string : String, exponent : Int) {
        var ti = number.d
        var ex : Int = Int(mp_exp_t()) // this is the deimal place
        let p = __gmpf_get_str(nil, &ex, CInt(base), 0, &ti)
        return (string : String(cString: p!), exponent : ex);
    }
    
    /**
     * Converts the number to a string in base 10
     * - parameter number: The number to be converted
     * - returns: A string representation of `number` in base 10
     */
    public static func string(_ number: GMPDouble) -> String {
        let strBase = self.strBase(number, 10)
        var string = strBase.string
        let exponent = strBase.exponent
        
        if string.isEmpty {
            return Double(0).description
        }
        
        let isNegative = string.first == "-" ? 1 : 0;
        
        //GraniteLogger.info("s: \(s) ex:" + String(ex) + " count: \(s?.characters.count) isNegative: " + String(isNegative))
        
        if(exponent > 0 && exponent < string.count - isNegative) {
            // add the decimal character to the floating point
            let si = string.index(string.startIndex, offsetBy: exponent + isNegative)
            string.insert(".", at: si)
        } else {
            // add necessary padding
            if exponent <= 0 {
                // the number has a leading zero ie (0.00000)1
                var news = "0."
                for _ in 0..<(-exponent) {
                    news = news + "0"
                }
                if isNegative > 0 {
                    string = "-" + news + String(string[string.index(string.startIndex, offsetBy: 1)...])
                } else {
                    string = news + string
                }
            } else {
                // the number does not have a decimal ie 1(00000)
                for _ in 0..<(exponent - string.count + isNegative) {
                    string.append("0")
                }
                string = string + ".0"
            }
        }
        
        return string
    }
    
    public var description : String {
        return GMPDouble.string(self)
    }
    
}

// for init with string
extension GMPDouble : LosslessStringConvertible { }
// for description
extension GMPDouble : CustomStringConvertible { }
// for operators
extension GMPDouble : Equatable, Comparable {
    public static func + (_ a : GMPDouble, _ b : GMPDouble) -> GMPDouble {
        return GMPDouble.add(a, b)
    }
    public static func + (_ a : GMPDouble, _ b : Double) -> GMPDouble {
        return GMPDouble.add(a, GMPDouble(b))
    }
    public static func + (_ a : Double, _ b : GMPDouble) -> GMPDouble {
        return GMPDouble.add(GMPDouble(a), b)
    }
    
    public static func - (_ a : GMPDouble, _ b : GMPDouble) -> GMPDouble {
        return GMPDouble.sub(a, b)
    }
    public static func - (_ a : GMPDouble, _ b : Double) -> GMPDouble {
        return GMPDouble.sub(a, GMPDouble(b))
    }
    public static func - (_ a : Double, _ b : GMPDouble) -> GMPDouble {
        return GMPDouble.sub(GMPDouble(a), b)
    }
    
    public static func * (_ a : GMPDouble, _ b : GMPDouble) -> GMPDouble {
        return GMPDouble.mul(a, b)
    }
    public static func * (_ a : GMPDouble, _ b : Double) -> GMPDouble {
        return GMPDouble.mul(a, GMPDouble(b))
    }
    public static func * (_ a : Double, _ b : GMPDouble) -> GMPDouble {
        return GMPDouble.mul(GMPDouble(a), b)
    }
    
    public static func / (_ a : GMPDouble, _ b : GMPDouble) -> GMPDouble {
        return GMPDouble.div(a, b)
    }
    public static func / (_ a : GMPDouble, _ b : Double) -> GMPDouble {
        return GMPDouble.div(a, GMPDouble(b))
    }
    public static func / (_ a : Double, _ b : GMPDouble) -> GMPDouble {
        return GMPDouble.div(GMPDouble(a), b)
    }
    
    public static func == (_ a : GMPDouble, _ b : GMPDouble) -> Bool {
        return GMPDouble.cmp(a, b) == 0 ? true : false
    }
    public static func == (_ a : GMPDouble, _ b : Double) -> Bool {
        return GMPDouble.cmp(a, GMPDouble(b)) == 0 ? true : false
    }
    public static func == (_ a : Double, _ b : GMPDouble) -> Bool {
        return GMPDouble.cmp(GMPDouble(a), b) == 0 ? true : false
    }
    
    public static func != (_ a : GMPDouble, _ b : GMPDouble) -> Bool {
        return GMPDouble.cmp(a, b) != 0 ? true : false
    }
    public static func != (_ a : GMPDouble, _ b : Double) -> Bool {
        return GMPDouble.cmp(a, GMPDouble(b)) != 0 ? true : false
    }
    public static func != (_ a : Double, _ b : GMPDouble) -> Bool {
        return GMPDouble.cmp(GMPDouble(a), b) != 0 ? true : false
    }
    
    
    public static func < (_ a : GMPDouble, _ b : GMPDouble) -> Bool {
        return GMPDouble.cmp(a, b) < 0 ? true : false
    }
    public static func < (_ a : GMPDouble, _ b : Double) -> Bool {
        return GMPDouble.cmp(a, GMPDouble(b)) < 0 ? true : false
    }
    public static func < (_ a : Double, _ b : GMPDouble) -> Bool {
        return GMPDouble.cmp(GMPDouble(a), b) < 0 ? true : false
    }
    
    public static func > (_ a : GMPDouble, _ b : GMPDouble) -> Bool {
        return GMPDouble.cmp(a, b) > 0 ? true : false
    }
    public static func > (_ a : GMPDouble, _ b : Double) -> Bool {
        return GMPDouble.cmp(a, GMPDouble(b)) > 0 ? true : false
    }
    public static func > (_ a : Double, _ b : GMPDouble) -> Bool {
        return GMPDouble.cmp(GMPDouble(a), b) > 0 ? true : false
    }
    
    public static func <= (_ a : GMPDouble, _ b : GMPDouble) -> Bool {
        return GMPDouble.cmp(a, b) <= 0 ? true : false
    }
    public static func <= (_ a : GMPDouble, _ b : Double) -> Bool {
        return GMPDouble.cmp(a, GMPDouble(b)) <= 0 ? true : false
    }
    public static func <= (_ a : Double, _ b : GMPDouble) -> Bool {
        return GMPDouble.cmp(GMPDouble(a), b) <= 0 ? true : false
    }
    
    public static func >= (_ a : GMPDouble, _ b : GMPDouble) -> Bool {
        return GMPDouble.cmp(a, b) >= 0 ? true : false
    }
    public static func >= (_ a : GMPDouble, _ b : Double) -> Bool {
        return GMPDouble.cmp(a, GMPDouble(b)) >= 0 ? true : false
    }
    public static func >= (_ a : Double, _ b : GMPDouble) -> Bool {
        return GMPDouble.cmp(GMPDouble(a), b) >= 0 ? true : false
    }
}
