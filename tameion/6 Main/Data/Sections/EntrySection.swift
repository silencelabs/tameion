//
//  EntrySection.swift
//  tameion
//
//  Created by Shola Ventures on 1/30/26.
//
import SwiftUI
import FirebaseCrashlytics

struct EntrySection: Identifiable {
    let id = UUID()
    var date: Date
    var entries: [Entry]

    var displayTitle: String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let entryDate = calendar.startOfDay(for: date)

        if entryDate == today {
            return "Today"
        } else if entryDate == calendar.date(byAdding: .day, value: -1, to: today) {
            return "Yesterday"
        } else if calendar.isDate(entryDate, equalTo: today, toGranularity: .weekOfYear) {
            return date.formatted(.dateTime.weekday(.wide))
        } else {
            return date.formatted(date: .abbreviated, time: .omitted)
        }
    }
}

//extension DatabaseService {
//    func getAllEntriesBySections(userId: String, journalId: String? = nil) throws -> [EntrySection] {
//        let entries: [Entry]
//        
//        if journalId != nil {
//            entries = self.activeEntries.filter {
//                $0.journalId == journalId //&& $0.deleted == false
//            }
//        } else {
//            entries = self.activeEntries //.filter { $0.deleted == false }
//        }
//        
//        let grouped = Dictionary(grouping: entries) { entry in
//            Calendar.current.startOfDay(for: entry.createdAt)
//        }
//        
//        return grouped.map { date, entries in
//            EntrySection(
//                date: date,
//                entries: entries.sorted { $0.createdAt > $1.createdAt }
//            )
//        }.sorted { $0.date > $1.date }
//    }
//}
