//
//  Formatter.swift
//  tameion
//
//  Created by Shola Ventures on 1/8/26.
//
import SwiftUI

enum DSFormatter {
    static func date(date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMM d, yyyy"
        return f.string(from: date)
    }

    static func shortDate(date: Date) -> String {
        let calendar = Calendar.current
        let f = DateFormatter()

        // Check if the provided date is in the same year as 'now'
        if calendar.isDate(date, equalTo: Date(), toGranularity: .year) {
            // Same year: e.g., "Mar 10"
            f.dateFormat = "MMM d"
        } else {
            // Different year: e.g., "Dec 12, 2025"
            f.dateFormat = "MMM d, yyyy"
        }

        return f.string(from: date)
    }

    static func longDate(date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "EEEE MMM d, yyyy"
        return f.string(from: date)
    }
    
    static func abbrevDate(date: Date) -> (dayOfWeek: String, dayOfMonth: String) {
        let dateFormatter = DateFormatter()
        
        // Set locale to ensure "EEE" and "d" work consistently, especially for fixed formats
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Format for 3-letter day of the week (e.g., "Mon", "Tue")
        dateFormatter.dateFormat = "EEE"
        let dayOfWeekString = dateFormatter.string(from: date)
        
        // Format for the day of the month (e.g., "4", "25")
        // Use "d" for a single digit if needed, or "dd" for a zero-padded two-digit day
        dateFormatter.dateFormat = "d"
        let dayOfMonthString = dateFormatter.string(from: date)
        
        return (dayOfWeekString, dayOfMonthString)
    }
    
    static func time(date: Date) -> String {
        let formatter = DateFormatter()

        formatter.dateStyle = .none // Hide the date part
        formatter.timeStyle = .short // Use short time format (e.g., 2:30 PM)

        return formatter.string(from: date)
    }

    static func timeAgo(from date: Date) -> String {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .weekOfYear, .day], from: date, to: now)

        if let years = components.year, years > 0 {
            return "\(years)y ago"
        } else if let months = components.month, months > 0 {
            return "\(months)m ago"
        } else if let weeks = components.weekOfYear, weeks > 0 {
            return "\(weeks)w ago"
        } else if let days = components.day, days > 0 {
            return "\(days)d ago"
        }

        return ""
    }

    static func relativeDate(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return "Today" }
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        
        let now = Date()
        if date > calendar.date(byAdding: .day, value: -7, to: now)! {
            formatter.dateFormat = "EEEE MMM d, yyyy"
            return formatter.string(from: date)
        }

        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }

    static func dateToUTCString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.string(from: date)
    }

    static func dateToTimeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    static func timeStringToDate(_ timeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: timeString)
    }

}

