//
//  EntryActionSection.swift
//  tameion
//
//  Created by Shola Ventures on 2/4/26.
//
import SwiftUI

struct EntryActionSection: Identifiable {
    let id = UUID()
    var title: String
    var helper: String
    var color: Color
    var entries: [Entry]
}

//extension DatabaseService {
//    func getAllEntriesByActionSections(userId: String, journalId: String? = nil) throws -> [EntryActionSection] {
//        let allEntries: [Entry]
//
//        if journalId != nil {
//            allEntries = self.activeEntries.filter {
//                $0.journalId == journalId
//            }
//        } else {
//            allEntries = self.activeEntries
//        }
//
//        // Filter to only action-required entries
//        let actionEntries = allEntries.filter { $0.actionRequired == true &&
//            $0.deleted == false  }
//
//        var sections: [EntryActionSection] = []
//
//        // Section 1: Urgent
//        sections.append(EntryActionSection(
//            title: DSCopy.Timeline.SeekSections.title1,
//            helper: DSCopy.Timeline.SeekSections.helper1,
//            color: DSColor.raspberry_red,
//            entries: actionEntries.filter { $0.urgency == .urgent && $0.obedienceStatus != .completed  }
//        ))
//
//        // Section 2: Needs Attention
//        sections.append(EntryActionSection(
//            title: DSCopy.Timeline.SeekSections.title2,
//            helper: DSCopy.Timeline.SeekSections.helper2,
//            color: DSColor.terracotta,
//            entries: actionEntries.filter {
//                $0.obedienceStatus != .completed && $0.urgency != .urgent && $0.obedienceStatus != .in_progress  && $0.obedienceStatus != .waiting
//            }
//        ))
//
//        // Section 3: Active
//        sections.append(EntryActionSection(
//            title: DSCopy.Timeline.SeekSections.title3,
//            helper: DSCopy.Timeline.SeekSections.helper3,
//            color: DSColor.mid_blue,
//            entries: actionEntries.filter {
//                $0.obedienceStatus == .in_progress && $0.urgency != .urgent
//            }
//        ))
//
//        // Section 4: Waiting
//        sections.append(EntryActionSection(
//            title: DSCopy.Timeline.SeekSections.title4,
//            helper: DSCopy.Timeline.SeekSections.helper4,
//            color: DSColor.gray,
//            entries: actionEntries.filter {
//                $0.obedienceStatus == .waiting && $0.urgency != .urgent
//            }
//        ))
//
//        // Filter out empty sections and return
//        return sections.filter { !$0.entries.isEmpty }
//    }
//}
