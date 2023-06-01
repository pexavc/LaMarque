//
//  Date.swift
//  
//
//  Created by PEXAVC on 1/5/21.
//

import Foundation
import CoreData

extension String {
    func asDate() -> Date? {
        return Calendar.nyDateFormatter.date(from: self)
    }
}

extension Date {
    var simple: Date {
        self.asString.asDate() ?? self
    }
    var asString: String {
        return Calendar.nyDateFormatter.string(from: self)
    }
    
    var asStringWithTime: String {
        return Calendar.nyTimeDayFormatter.string(from: self)
    }
    
    func asStringTimedWithTime(_ second: Int) -> String {
        return self.advanceDateBySeconds(value: second).asStringWithTime
    }
    
    func advanceDate(value: Int = 1) -> Date {
        return Calendar.nyCalendar.date(byAdding: .day, value: value, to: self) ?? self
    }
    
    func advanceDateHourly(value: Int = 1) -> Date {
        return Calendar.nyCalendar.date(byAdding: .hour, value: value, to: self) ?? self
    }
    
    func advanceDateBySeconds(value: Int = 1) -> Date {
        return Calendar.nyCalendar.date(byAdding: .second, value: value, to: self) ?? self
    }
    
    public static var today: Date {
        let formatter = DateFormatter()
        formatter.timeZone = Calendar.nyTimezone
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        
        let date: Date = Date()
        
        let nyDateAsString = formatter.string(from: date)
        
        return formatter.date(from: nyDateAsString) ?? date
        
    }
    
    func dateComponents() -> (year: Int, month: Int, day: Int) {
        let calendar = Calendar.nyCalendar
        
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        
        return(year, month, day)
    }
    
    func timeComponents() -> (hour: Int, minute: Int, seconds: Int) {
        let time = Calendar.nyTimeFormatter.string(from: self)
        let components = time.components(separatedBy: ":")
        var hour: Int = 0
        var minute: Int = 0
        var seconds: Int = 0
        if components.count == 3 {
            hour = Int(components[0]) ?? 0
            minute = Int(components[1]) ?? 0
            seconds = Int(components[2]) ?? 0
        }
        return (hour, minute, seconds)
    }
    
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    var dayofTheWeek: Weekday {
        let dayNumber = Calendar.current.component(.weekday, from: self)
        // day number starts from 1 but array count from 0
        return Weekday.init(rawValue: dayNumber - 1) ?? Weekday.unknown
    }
    
    public enum Weekday: Int {
        case sunday
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case unknown
        
        var isWeekend: Bool {
            return self == .sunday || self == .saturday
        }
    }
    
    func daysFrom(_ date: Date) -> Int {
        let todaysDate = self
        let latestTickerDate = date
        let components = Calendar.nyCalendar.dateComponents([.day], from: latestTickerDate, to: todaysDate)
        
        return abs(components.day ?? 0)
    }
    
    func hoursFrom(_ date: Date) -> Int {
        let todaysDate = self
        let latestTickerDate = date
        let components = Calendar.nyCalendar.dateComponents([.hour], from: latestTickerDate, to: todaysDate)
        
        return abs(components.hour ?? 0)
        
    }
    
    func minutesFrom(_ date: Date) -> Int {
        let diff = Int(date.timeIntervalSince1970 - self.timeIntervalSince1970)

        let hours = diff / 3600
        let minutes = (diff - hours * 3600) / 60
        return minutes
    }
    
    func secondsFrom(_ date: Date) -> Int {
        let diff = abs(Int(date.timeIntervalSince1970 - self.timeIntervalSince1970))

        let hours = diff / 3600
        let seconds = (diff - hours * 3600)
        return seconds
    }
}

//MARK: -- Sorting
extension Array where Element == Date {
    public var sortAsc: [Date] {
        self.sorted(by: { $0.compare($1) == .orderedAscending })
    }
    
    public var sortDesc: [Date] {
        self.sorted(by: { $0.compare($1) == .orderedDescending })
    }
    
    public func filterAbove(_ date: Date) -> [Date] {
        return self.filter( { date.compare($0) == .orderedAscending })
    }
    
    public func filterBelow(_ date: Date) -> [Date] {
        return self.filter( { date.compare($0) == .orderedDescending })
    }
}

//MARK: -- Calendar Configurations
extension Calendar {
    static var nyTimezone: TimeZone {
        return TimeZone(identifier: "America/New_York") ?? .current
    }
    
    static var nyCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = Calendar.nyTimezone
        
        return calendar
    }
    
    static var nyDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = Calendar.nyTimezone
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
    
    static var nyTimeFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = Calendar.nyTimezone
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }
    
    static var nyTimeDayFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = Calendar.nyTimezone
        dateFormatter.dateFormat = "HH:mm:ss // MM/dd"
        return dateFormatter
    }
}

extension Double {
    func date() -> Date {
        let unixDate: Double = self
        let date = Date.init(timeIntervalSince1970: TimeInterval(unixDate))
        return date
    }
}

//MARK: -- Stocks
extension Date {
    static var nextTradingDay: Date {
        let today: Date = Date.today
        let todaysHour = today.timeComponents().hour
        
        if  todaysHour < today.closingHour &&
            today.validTradingDay {
            return today
        } else {
        
            var days: [Date] = []
            
            for i in 1..<13 {
                days.append(today.advanceDate(value: i))
            }
            
            var nextTradingDate: Date = today
            
            for day in days {
                if day.validTradingDay {
                    nextTradingDate = day
                    break
                }
            }
            
            return nextTradingDate
        }
    }
    
    var validTradingDay: Bool {
        !self.dayofTheWeek.isWeekend && !self.isUSHoliday
    }
    
    var closingHour: Int {
        if let tgDay = Date.thanksGivingDay(year: self.dateComponents().year) {
            let theDayAfterTG = tgDay.advanceDate(value: 1)
            let selfComponents = self.dateComponents()
            let theDayAfterTGComponents = theDayAfterTG.dateComponents()
            if selfComponents.day == theDayAfterTGComponents.day &&
               selfComponents.year == theDayAfterTGComponents.year {
                return 13 //The day after thanksgiving closes at 1pm
            }
        }
        
        return 16 //normal open stock market days closes at 4pm
    }
    
    var openingHour: Int {
        9
    }
}

//MARK: -- Holidays
extension Date {
    var isUSHoliday: Bool {
        let components = Calendar.current.dateComponents([.year, .month, .day, .weekday, .weekdayOrdinal], from: self)
        guard let year = components.year,
              let month = components.month,
              let day = components.day,
              let weekday = components.weekday,
              let weekdayOrdinal = components.weekdayOrdinal else { return false }
        
        let easterDateComponents = Date.dateComponentsForEaster(year: year)
        let easterMonth: Int = easterDateComponents?.month ?? -1
        let easterDay: Int = easterDateComponents?.day ?? -1
        let memorialDay = Date.dateComponentsForMemorialDay(year: year)?.day ?? -1
        
        // weekday is Sunday==1 ... Saturday==7
        // weekdayOrdinal is nth instance of weekday in month
        
        switch (month, day, weekday, weekdayOrdinal) {
        case (1, 1, _, _): return true                      // Happy New Years
        case (1, _, 2, 3): return true                      // Martin Luther King - 3rd Mon in Jan
        case (2, 14, _, _): return true                     // Valentine day - 14th in Feb
        case (2, _, 2, 3): return true                      // Washington's Birthday - 3rd Mon in Feb
        case (3, 17, _, _): return true                     // Saint Patrick's Day - 17th Mar
        case (easterMonth, easterDay, _, _): return true    // Easter - rocket science calculation
        case (5, _, 1, 2): return true                      // Mothers day - 2nd Sun in May
        case (5, memorialDay, _, _): return true            // Memorial Day
        case (5, _, 1, 3): return true                      // Fathers day - 3rd Sun in May
        case (7, 4, _, _): return true                      // Independence Day - 4th July
        case (9, _, 2, 1): return true                      // Labor Day - 1st Mon in Sept
        case (10, _, 2, 2): return true                     // Columbus Day - 2nd Mon in Oct
        case (10, 31, _, _): return true                    // Halloween Day - 31st Oct
        case (11, 11, _, _): return true                    // Veterans Day  - 11th Nov
        case (11, _, 5, 4): return true                     // Happy Thanksgiving - 4th Thurs in Nov
        case (12, 25, _, _): return true                    // Christmas/Happy Holiday
        case (12, 31, _, _): return true                    // New years Eve
        default: return false
        }
        
    }
    //New Year
    static func newYearDay(year: Int) -> Date? {
        var firstDayJan = DateComponents()
        firstDayJan.month = 1 // 1st Month
        firstDayJan.day  = 1  // 1st Day
        firstDayJan.year = year
        return Calendar.current.date(from: firstDayJan)
    }
    // Martin Luther King Jr Day
    static func martinLKDay(year: Int) -> Date? {
        var thirdMonJan = DateComponents()
        thirdMonJan.month = 1 //1 month
        thirdMonJan.weekday  = 2 // Monday
        thirdMonJan.weekdayOrdinal = 3 //3rd week
        thirdMonJan.year = year
        return Calendar.current.date(from: thirdMonJan)
    }
    //Valentine Day
    static func valentineDay(year: Int) -> Date? {
        var firstDayFeb = DateComponents()
        firstDayFeb.month = 2
        firstDayFeb.day  = 14
        firstDayFeb.year = year
        return Calendar.current.date(from: firstDayFeb)
    }
    //Washington's Birthday
    static func washingtonBDay(year: Int) -> Date? {
        var thirdMonFeb = DateComponents()
        thirdMonFeb.month = 2 //month Feb
        thirdMonFeb.weekday  = 2 // Monday
        thirdMonFeb.weekdayOrdinal = 3 //3rd week
        thirdMonFeb.year = year
        return Calendar.current.date(from: thirdMonFeb)
    }
    //Saint Patrick's Day
    static func stPatrickDay(year: Int) -> Date? {
        var seventeenthMar = DateComponents()
        seventeenthMar.month = 3
        seventeenthMar.day  = 17
        seventeenthMar.year = year
        return Calendar.current.date(from: seventeenthMar)
    }
    //Easter
    static func easterHoliday(year: Int) -> Date? {
        guard let dateComponents = Date.dateComponentsForEaster(year: year) else { return nil }
        return Calendar.current.date(from: dateComponents)
    }
    
    static func dateComponentsForEaster(year: Int) -> DateComponents? {
        // Easter calculation from Anonymous Gregorian algorithm
        // AKA Meeus/Jones/Butcher algorithm
        let a = year % 19
        let b = Int(floor(Double(year) / 100))
        let c = year % 100
        let d = Int(floor(Double(b) / 4))
        let e = b % 4
        let f = Int(floor(Double(b+8) / 25))
        let g = Int(floor(Double(b-f+1) / 3))
        let h = (19*a + b - d - g + 15) % 30
        let i = Int(floor(Double(c) / 4))
        let k = c % 4
        let L = (32 + 2*e + 2*i - h - k) % 7
        let m = Int(floor(Double(a + 11*h + 22*L) / 451))
        var dateComponents = DateComponents()
        dateComponents.month = Int(floor(Double(h + L - 7*m + 114) / 31))
        dateComponents.day = ((h + L - 7*m + 114) % 31) + 1
        dateComponents.year = year
        guard let easter = Calendar.current.date(from: dateComponents) else { return nil } // Convert to calculate weekday, weekdayOrdinal
        return Calendar.current.dateComponents([.year, .month, .day, .weekday, .weekdayOrdinal], from: easter)
    }
    //Mother's Days
    static func mothersDay(year: Int) -> Date? {
        var secondSunMay = DateComponents()
        secondSunMay.month = 5
        secondSunMay.weekday = 1
        secondSunMay.weekdayOrdinal = 2
        secondSunMay.year = year
        return Calendar.current.date(from: secondSunMay)
    }
    
    //Memorial Day
    static func dateComponentsForMemorialDay(year: Int) -> DateComponents? {
        guard let memorialDay = Date.memorialDay(year: year) else { return nil }
        return NSCalendar.current.dateComponents([.year, .month, .day, .weekday, .weekdayOrdinal], from: memorialDay)
    }
    static func memorialDay(year: Int) -> Date? {
        let calendar = Calendar.current
        var firstMondayJune = DateComponents()
        firstMondayJune.month = 6
        firstMondayJune.weekdayOrdinal = 1  // 1st in month
        firstMondayJune.weekday = 2 // Monday
        firstMondayJune.year = year
        guard let refDate = calendar.date(from: firstMondayJune) else { return nil }
        var timeMachine = DateComponents()
        timeMachine.weekOfMonth = -1
        return calendar.date(byAdding: timeMachine, to: refDate)
    }
    //Fathers Day
    static func fathersDay(year: Int) -> Date? {
        var thirdSunJun = DateComponents()
        thirdSunJun.month = 6
        thirdSunJun.weekday = 1
        thirdSunJun.weekdayOrdinal = 3
        thirdSunJun.year = year
        return Calendar.current.date(from: thirdSunJun)
    }
    
    //Independence Day
    static func independenceDay(year: Int) -> Date? {
        var fourthJuly = DateComponents()
        fourthJuly.month = 7
        fourthJuly.day = 4
        fourthJuly.year = year
        return Calendar.current.date(from: fourthJuly)
    }
    //Labor Day
    static func laborDay(year: Int) -> Date? {
        var firstSunSep = DateComponents()
        firstSunSep.month = 9
        firstSunSep.weekday = 2
        firstSunSep.weekdayOrdinal = 1
        firstSunSep.year = year
        return Calendar.current.date(from: firstSunSep)
    }
    //Columbus Day
    static func columbusDay(year: Int) -> Date? {
        var firstSunSep = DateComponents()
        firstSunSep.month = 10
        firstSunSep.weekday = 2
        firstSunSep.weekdayOrdinal = 2
        firstSunSep.year = year
        return Calendar.current.date(from: firstSunSep)
    }
    //Halloween
    static func halloweenDay(year: Int) -> Date? {
        var thirtyFirstOct = DateComponents()
        thirtyFirstOct.month = 10
        thirtyFirstOct.day = 31
        thirtyFirstOct.year = year
        return Calendar.current.date(from: thirtyFirstOct)
    }
    
    //Veterans
    static func veteransDay(year: Int) -> Date? {
        var eleventhNov = DateComponents()
        eleventhNov.month = 11
        eleventhNov.day = 11
        eleventhNov.year = year
        return Calendar.current.date(from: eleventhNov)
    }
    //Thanks Giving Day
    static func thanksGivingDay(year: Int) -> Date? {
        var fourthThuNov = DateComponents()
        fourthThuNov.month = 11
        fourthThuNov.weekday = 5
        fourthThuNov.weekdayOrdinal = 4
        fourthThuNov.year = year
        return Calendar.current.date(from: fourthThuNov)
    }
    //Christmas
    static func christmasDay(year: Int) -> Date? {
        var christmasDay = DateComponents()
        christmasDay.month = 12
        christmasDay.day = 25
        christmasDay.year = year
        return Calendar.current.date(from: christmasDay)
    }
    
    //New Year Eve
    static func newYearEve(year: Int) -> Date? {
        var thirtyFirstDec = DateComponents()
        thirtyFirstDec.month = 12
        thirtyFirstDec.day = 31
        thirtyFirstDec.year = year
        return Calendar.current.date(from: thirtyFirstDec)
    }
    
    
    static func getHolidayArray(year: Int) -> [Date?] {
        return [newYearEve(year:year),Date.martinLKDay(year: year),Date.valentineDay(year: year),Date.washingtonBDay(year: year),Date.stPatrickDay(year: year),Date.easterHoliday(year: year),Date.mothersDay(year: year),Date.memorialDay(year: year),Date.fathersDay(year: year),Date.independenceDay(year: year),Date.laborDay(year: year),Date.columbusDay(year: year),Date.halloweenDay(year: year),Date.veteransDay(year: year),Date.thanksGivingDay(year: year),Date.christmasDay(year: year),Date.newYearEve(year: year)]
    }
}
