//
//  MockDatabaseService.swift
//  tameion
//
//  Created by Shola Ventures on 2/4/26.
//
import SwiftUI
import FirebaseCrashlytics

extension DatabaseService {

    func createMockData() {

        let jid1: String = "EDFD1682-4920-4E4F-97D9-D3BE0813BFCB"
        let jid2: String = "45FE7A25-18C4-46C2-987D-4BB705E06A3F"
        let jid3: String = "EF6313A3-D081-4A96-B7EE-E3817186A675"
        let uid: String = "PFLZcZwE0Qc1e6mk27kdQ6q6B172"
        let calendar = Calendar.current
        let now = Date()        // calendar.date(byAdding: .day, value: -7, to: now)

        let entries = [
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .note,
                title: "Settling In",
                previewText: "I've been in Melbourne for 3 months now and I love it. It's an amazing feeling to be here and oddly satisfying and validating to be honest. It has just been working and I'm excited about it.",
                actionRequired: false,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: now,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .note,
                title: "",
                previewText: "It’s been a few hours. I’m hoarding my flight to Maryland. I started crying earlier when I tried to write this note. I’ve been such an emotional mess lately. Any and everything has been making me cry. Honestly, writing about this again is getting to me. I’m struggling. ",
                actionRequired: false,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .day, value: -1, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .note,
                title: "Delayed Fallen Monkeys",
                previewText: "",
                actionRequired: true,
                dueDate: calendar.date(byAdding: .day, value: +3, to: now)!,
                obedienceStatus: .delayed,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .day, value: -1, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .note,
                title: "",
                previewText: "",
                actionRequired: false,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .day, value: -2, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .promise,
                title: "Things God Has Told Me",
                previewText: "Promises Financial windfall (October 2024) Confirmed by Bisi’s mom in May 2025 Confirmed again by Bisi’s mom in June 2025 (that I’d be in Atlanta when I received  the call about the opportunity). Husband Confirmed by Bisi’s mom in May 2025 that I’d meet someone once I moved to a new city",
                actionRequired: true,
                obedienceStatus: .waiting,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .day, value: -1, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .promise,
                title: "Secrecy",
                previewText: "Protecting god’s secrets, assignment, tongue ",
                actionRequired: false,
                obedienceStatus: .waiting,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .day, value: -3, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .dream,
                title: "Settling In",
                previewText: "I've been in Melbourne for 3 months now and I love it. It's an amazing feeling to be here and oddly satisfying and validating to be honest. It has just been working and I'm excited about it.",
                actionRequired: true,
                obedienceStatus: .in_progress,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .day, value: -4, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .dream,
                title: "Being a woman",
                previewText: "Last week I discovered Rivah TV, she’s been giving me my daily dose of reality, how others view me and how I take up space in the world. I’ve learned a lot about being a woman (by worldly standards). Basically your job is to look beautiful and give your enemies nothing. It’s also to be an encouraging support system for your spouse.",
                actionRequired: false,
                obedienceStatus: .completed,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 1
                ),
                createdAt: calendar.date(byAdding: .day, value: -5, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .dream,
                title: "Understanding Women and Men",
                previewText: "I think I’ve unlocked a new level of understanding on who women are and what happened. Ultimately, B lost respect for me because I lost my money and status. Once she became affected by loss and then unable to benefit financially and now emotionally,",
                actionRequired: false,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .day, value: -6, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .prayer,
                title: "Mom in Hospice",
                previewText: "I've been in Melbourne for 3 months now and I love it. It's an amazing feeling to be here and oddly satisfying and validating to be honest. It has just been working and I'm excited about it.",
                actionRequired: true,
                estimatedEffort: .ongoing,
                obedienceStatus: .in_progress,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .day, value: -7, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .prayer,
                title: "Moving On From Being Too Nice",
                previewText: "Have you ever been told those words? I’m too nice, too gullible, too oblivious. Did you catch that? Shade thrown so covertly,",
                actionRequired: true,
                estimatedEffort: .quick,
                obedienceStatus: .in_progress,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .day, value: -14, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .prayer,
                title: "Just Doing",
                previewText: "I’m getting ready to leave Bianca’s place. This has been such a great break for me. I just realized, I haven’t yet booked my tickets to Maryland or Barbados and I didn’t know why but I was delaying it. As I type this, I think I’m afraid of the unknown. I’m afraid of losing and forgetting myself. I’m afraid I won’t land the job. I’m afraid I’ll be stuck forever. I’m afraid Barbados won’t be able to give me what I’m searching for.",
                actionRequired: true,
                estimatedEffort: .ongoing,
                obedienceStatus: .in_progress,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .day, value: -21, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .note,
                title: "Settling In",
                previewText: "I've been in Melbourne for 3 months now and I love it. It's an amazing feeling to be here and oddly satisfying and validating to be honest. It has just been working and I'm excited about it.",
                actionRequired: false,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .month, value: -1, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .prayer,
                title: "Hopefuly For a New Role",
                previewText: "I need to get a job so I can comfortably afford my own place, move out of Maryland and get back onto my feet.",
                actionRequired: false,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .month, value: -2, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .praise,
                title: "Melbourne Library In",
                previewText: "I've been in Melbourne for 3 months now and I love it. It's an amazing feeling to be here and oddly satisfying and validating to be honest. It has just been working and I'm excited about it.",
                actionRequired: false,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .month, value: -3, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .praise,
                title: "Beauty",
                previewText: "I was listening to a YouTube video where the speaker talked about how much she valued beauty. It made me wonder to myself, ",
                actionRequired: true,
                estimatedEffort: .ongoing,
                obedienceStatus: .in_progress,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .month, value: -4, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .revelation,
                title: "On track to lose 300!",
                previewText: "Similarly, I desire to lose so much weight and yet when hunger calls, I’m ready to get fast food. Why? My actions don’t consistent show my values. Why? ",
                actionRequired: false,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .month, value: -5, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .revelation,
                title: "Testing how a very long title looks like in the list and here is what it would do. should this have a limit?",
                previewText: "I've been in Melbourne for 3 months now and I love it. It's an amazing feeling to be here and oddly satisfying and validating to be honest. It has just been working and I'm excited about it.",
                actionRequired: true,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .month, value: -6, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .interpretation,
                title: "Money Insecurity",
                previewText: "This morning I spoke to God. I need to redo my apartment, redo my closet, and get my body right. As I thought about my financial situation, im running on slim margins. I’m really hitting my rock bottom. As I ran the numbers, I realized I might have to take out of my 401k this year might force.",
                actionRequired: false,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .year, value: -1, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .interpretation,
                title: "beautifying myself on a daily",
                previewText: "I’m obsessed with beautifying myself but when it comes to day-to-day discipline, I will just “pull myself together” and make myself acceptable. Not pretty but acceptable. ",
                actionRequired: true,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .year, value: -2, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .warning,
                title: "Don't Speak On It",
                previewText: "As I watched Beyoncé, I thought about how frequently she tells people how she feels through her art but she never speaks on issues surrounding her. I want to be just like that. ",
                actionRequired: true,
                dueDate: calendar.date(byAdding: .day, value: -3, to: now)!,
                urgency: .urgent,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .year, value: -3, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .warning,
                title: "children 🧒",
                previewText: "People are children. They are not at a frequency to perceive or engage with me and that’s ok. ",
                actionRequired: false,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .year, value: -1, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .fast,
                title: "🔥🔥🔥",
                previewText: "ok.",
                actionRequired: true,
                dueDate: now,
                urgency: .low,
                obedienceStatus: .in_progress,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .month, value: -8, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .fast,
                title: "Hearing It Out",
                previewText: "Both Kendrick and Beyoncé are Libra risings, I will take my cue from them and let my thoughts show through my art. When I think about it, art is subjective but its openness allows people to digest it on their own timeline and their own way.",
                actionRequired: true,
                dueDate: nil,
                urgency: .low,
                obedienceStatus: .in_progress,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .day, value: -51, to: now)!,
                updatedAt: now,
                deleted: false
                ),




            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .testimony,
                title: "Just Doing",
                previewText: "I’m getting ready to leave Bianca’s place. This has been such a great break for me. I just realized, I haven’t yet booked my tickets to Maryland or Barbados and I didn’t know why but I was delaying it. As I type this, I think I’m afraid of the unknown. I’m afraid of losing and forgetting myself. I’m afraid I won’t land the job. I’m afraid I’ll be stuck forever. I’m afraid Barbados won’t be able to give me what I’m searching for.",
                actionRequired: true,
                estimatedEffort: .ongoing,
                obedienceStatus: .in_progress,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .day, value: -21, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .testimony,
                title: "Settling In",
                previewText: "I've been in Melbourne for 3 months now and I love it. It's an amazing feeling to be here and oddly satisfying and validating to be honest. It has just been working and I'm excited about it.",
                actionRequired: false,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .month, value: -1, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .instruction,
                title: "Hopefuly For a New Role",
                previewText: "I need to get a job so I can comfortably afford my own place, move out of Maryland and get back onto my feet.",
                actionRequired: true,
                estimatedEffort: .ongoing,
                obedienceStatus: .in_progress,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .month, value: -2, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .instruction,
                title: "Melbourne Library In",
                previewText: "I've been in Melbourne for 3 months now and I love it. It's an amazing feeling to be here and oddly satisfying and validating to be honest. It has just been working and I'm excited about it.",
                actionRequired: true,
                estimatedEffort: .ongoing,
                obedienceStatus: .waiting,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .month, value: -3, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .instruction,
                title: "Beauty",
                previewText: "I was listening to a YouTube video where the speaker talked about how much she valued beauty. It made me wonder to myself, ",
                actionRequired: true,
                estimatedEffort: .ongoing,
                obedienceStatus: .completed,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .month, value: -4, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .instruction,
                title: "On track to lose 300!",
                previewText: "Similarly, I desire to lose so much weight and yet when hunger calls, I’m ready to get fast food. Why? My actions don’t consistent show my values. Why? ",
                actionRequired: false,
                dueDate: now,
                estimatedEffort: .ongoing,
                obedienceStatus: .in_progress,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .month, value: -5, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .instruction,
                title: "Testing how a very long title looks like in the list and here is what it would do. should this have a limit?",
                previewText: "I've been in Melbourne for 3 months now and I love it. It's an amazing feeling to be here and oddly satisfying and validating to be honest. It has just been working and I'm excited about it.",
                actionRequired: true,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .month, value: -6, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .instruction,
                title: "Money Insecurity",
                previewText: "This morning I spoke to God. I need to redo my apartment, redo my closet, and get my body right. As I thought about my financial situation, im running on slim margins. I’m really hitting my rock bottom. As I ran the numbers, I realized I might have to take out of my 401k this year might force.",
                actionRequired: false,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .year, value: -1, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .instruction,
                title: "beautifying myself on a daily",
                previewText: "I’m obsessed with beautifying myself but when it comes to day-to-day discipline, I will just “pull myself together” and make myself acceptable. Not pretty but acceptable. ",
                actionRequired: true,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .year, value: -2, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid1,
                author: Author.system,
                type: .instruction,
                title: "Don't Speak On It",
                previewText: "As I watched Beyoncé, I thought about how frequently she tells people how she feels through her art but she never speaks on issues surrounding her. I want to be just like that. ",
                actionRequired: true,
                dueDate: calendar.date(byAdding: .day, value: -3, to: now)!,
                urgency: .urgent,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .year, value: -3, to: now)!,
                updatedAt: now,
                deleted: false
                ),

        ]

        let entrie2 = [
            Entry(
                userId: uid,
                journalId: jid2,
                author: Author.system,
                type: .note,
                title: "Settling In",
                previewText: "I've been in Melbourne for 3 months now and I love it. It's an amazing feeling to be here and oddly satisfying and validating to be honest. It has just been working and I'm excited about it.",
                actionRequired: false,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: now,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid3,
                author: Author.system,
                type: .note,
                title: "",
                previewText: "It’s been a few hours. I’m hoarding my flight to Maryland. I started crying earlier when I tried to write this note. I’ve been such an emotional mess lately. Any and everything has been making me cry. Honestly, writing about this again is getting to me. I’m struggling. ",
                actionRequired: false,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .day, value: -1, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid2,
                author: Author.system,
                type: .note,
                title: "Delayed Fallen Monkeys",
                previewText: "",
                actionRequired: true,
                dueDate: calendar.date(byAdding: .day, value: +3, to: now)!,
                obedienceStatus: .delayed,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .day, value: -1, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid2,
                author: Author.system,
                type: .note,
                title: "",
                previewText: "",
                actionRequired: false,
                obedienceStatus: EntryStatus.not_started,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .day, value: -2, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid2,
                author: Author.system,
                type: .promise,
                title: "Things God Has Told Me",
                previewText: "Promises Financial windfall (October 2024) Confirmed by Bisi’s mom in May 2025 Confirmed again by Bisi’s mom in June 2025 (that I’d be in Atlanta when I received  the call about the opportunity). Husband Confirmed by Bisi’s mom in May 2025 that I’d meet someone once I moved to a new city",
                actionRequired: true,
                obedienceStatus: .waiting,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .day, value: -1, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid2,
                author: Author.system,
                type: .promise,
                title: "Secrecy",
                previewText: "Protecting god’s secrets, assignment, tongue ",
                actionRequired: false,
                obedienceStatus: .waiting,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .day, value: -3, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid3,
                author: Author.system,
                type: .dream,
                title: "Settling In",
                previewText: "I've been in Melbourne for 3 months now and I love it. It's an amazing feeling to be here and oddly satisfying and validating to be honest. It has just been working and I'm excited about it.",
                actionRequired: true,
                obedienceStatus: .in_progress,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .day, value: -4, to: now)!,
                updatedAt: now,
                deleted: false
                ),
            Entry(
                userId: uid,
                journalId: jid3,
                author: Author.system,
                type: .dream,
                title: "Being a woman",
                previewText: "Last week I discovered Rivah TV, she’s been giving me my daily dose of reality, how others view me and how I take up space in the world. I’ve learned a lot about being a woman (by worldly standards). Basically your job is to look beautiful and give your enemies nothing. It’s also to be an encouraging support system for your spouse.",
                actionRequired: false,
                obedienceStatus: .completed,
                remembranceCadence: RemembranceCadence.none,
                reminderCadence: ReminderCadence.none,
                references: ReferenceStats(
                    scriptureCount: 0,
                    scripturePreview: [],
                    symbolCount: 0,
                    symbolPreview: []
                ),
                responseStats: ResponseStats(
                    prayerCount: 0,
                    praiseCount: 0,
                    fastCount: 0,
                    obedienceCount: 0,
                    testimonyCount: 0,
                    confirmationCount: 0,
                    interpretationsCount: 0
                ),
                createdAt: calendar.date(byAdding: .day, value: -5, to: now)!,
                updatedAt: now,
                deleted: false
                ),
        ]


        for entry in entries {
            Task {
                await createEntry(entry)
            }
        }

        for entry in entrie2 {
            Task {
                await createEntry(entry)
            }
        }

    }
}
