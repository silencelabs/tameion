//
//  CTA.swift
//  tameion
//
//  Created by Shola Ventures on 1/9/26.
//

enum DSCopy {
    enum CTA {
        static let get_started = "Get Started"
        static let continued = "Continue"
        static let save = "Save"
        static let cancel = "Cancel"
        static let done = "Done"
        static let delete = "Delete"
        static let retry = "Try Again"
        
        static func delete(_ item: String) -> String {
            "Delete \(item)"
        }
        static let submitFeedback = "Submit it here © 2025"

    }
}

extension DSCopy {
    enum Navigation {
        enum ReflectTab {
            static let name = "Reflect"
            static let systemImage = "book"
        }
        enum PraiseTab {
            static let name = "Praise"
            static let systemImage = "music.note.list"
        }
        enum SeekTab {
            static let name = "Seek"
            static let systemImage = "hands.and.sparkles"
        }
        enum AddEntry {
            static let name = "Add"
            static let systemImage = "square.and.pencil"
        }
        enum Settings {
            static let name = "Settings"
            static let systemImage = "gear"
            static let title = "Account Management"
        }
        enum Account {
            static let name = "Account Management"
            static let systemImage = "person"
            static let title = "Account Management"

        }
    }
}

extension DSCopy {
    enum Auth {
        static let welcome = "Welcome to your inner room"
        static let subheading = "Sign in to keep your spiritual journey safe and synced across all your devices"
        static let promise = "End-to-end encrypted.\nEven we can't read your entries."
        static let promiseAbbreviated = "End-to-end encrypted."
        static let promise2 = "Privacy First."
        static let signout = "Sign Out"

        enum SignIn {
            static let namePlaceholder = "Name"
            static let emailPlaceholder = "Email"
            static let passwordPlaceholder = "Password"
            static let confirmPasswordPlaceholder = "Confirm Password"
            static let forgotPassword = "Forgot Password?"
            static let noAccount = "Don't have an account?"
            static let register = "Register"
            static let signUp = "Sign Up"
            static let login = "Login"
            static let signInButtonTitle = "Sign In"
            static let withEmail = "Sign In With Email"
            static let withApple = "Sign In With Apple"
            static let withGoogle = "Sign In With Google"
        }
    }
    enum Timeline {
        static let metadataSeparator = "•"
        static let dueDatePrefix = "Due "

        enum SeekSections {
            static let title1 = "Urgent"
            static let title2 = "Not Started"
            static let title3 = "Active"
            static let title4 = "Waiting"
            static let helper1 = "Entries that are overdue and require swift response."
            static let helper2 = "Entries that are waiting for you to act."
            static let helper3 = "Entries that require ongoing action such as a fast or prayer."
            static let helper4 = "Entries that have been paused."
        }
    }
    enum ProgressView {
        static let syncing = "Syncing..."
        static let loadingEntries = "Loading entries..."
        static let noEntries = "No entries"
        static let noEntriesEncouragement = "Start journaling to see your entries here"
        static let noFilteredEntries = "No action items for this journal"
        static let noFilteredEntriesEncouragement = "Add an actionable entry to get started"
    }
}

extension DSCopy {
    enum Onboarding {
        enum Welcome {
            static let headline = "Remember God's Voice"
            static let subheading = "Your spiritual journal for dreams, prayers, and promises"
        }

        enum Questions {
            static let headline = "Help Us Personalize Your Experience"

            enum age_range {
                static let question = "How old are you?"
                static let answer_1 = "Under 18"
                static let answer_2 = "18-24"
                static let answer_3 = "25-34"
                static let answer_4 = "35-44"
                static let answer_5 = "45-54"
                static let answer_6 = "55+"
            }

            enum journaling_habits {
                static let question = "Do you currently journal?"
                static let answer_1 = "Yes, Daily"
                static let answer_2 = "Yes, Weekly"
                static let answer_3 = "Yes, Monthly"
                static let answer_4 = "Sometimes"
                static let answer_5 = "Rarely"
                static let answer_6 = "No, but I Want to"
            }

            // "Yes, regularly", "Sometimes", "No, but interested"
            enum bible_habits {
                static let question = "How often do you read the Bible?"
                static let answer_1 = "Daily"
                static let answer_2 = "Weekly"
                static let answer_3 = "Monthly"
                static let answer_4 = "Occasionally"
                static let answer_5 = "Rarely"
                static let answer_6 = "I Don't But I Want to Start"
            }

            enum product_goals {
                static let question = "What brings you to Tameion?"
                static let answer_1 = "Understand dreams biblically"
                static let answer_2 = "Track God's promises"
                static let answer_3 = "Deepen Bible study"
                static let answer_4 = "Prayer journaling"
                static let answer_5 = "Remember God's faithfulness"
                static let answer_6 = "Other reason, not stated"
            }

        }

        enum Notifications {
            static let headline = "Stay Consistent"
            static let subheading = "We'll send you one daily reminder to reflect and journal."
            static let enable_reminders = "Enable reminders"
        }

        enum Security {
            static let headline = "Protect Your Journal"
            static let subheading = "Lock your journal with Face ID for extra security."
            static let enable_faceid = "Require Face ID to open"
        }

        enum FirstJournal {
            static let headline = "Create Your First Journal"
            static let subheading = "You can create more journals later to organize different topics."
            static let journalNamePlaceholder = "My Journal"
            static let cta = "Create Journal"
        }
    }
}

extension DSCopy {
    enum Legal {
        static let copyright = "Tameion © 2026"

    }
}

extension DSCopy {
    enum Assets {
        enum Logos {
            static let google = "google"
        }

        enum SFSymbols {
            static let helper = "info.circle"
        }
    }
}


extension DSCopy {
    enum EmptyState {
        static let noResultsTitle = "No results"
        static let noResultsBody = "Try adjusting your search."
    }
}

extension DSCopy {
    enum Error {
        static let genericTitle = "Something went wrong"
        static let genericBody = "Please try again."
        static let when = " when "

        enum NotExpected {
            static let noUserId = "No user id can be found."
        }

        enum Location {
            enum DataService {
                static let setActiveJournal = "trying to set the active journal in DataService."
                static let setActiveUser = "trying to set the active user in DataService."
            }
            enum FirstJournalView {
                static let createJournal = "trying to create a journal in FirstJournalView."
            }

            enum MainView {
                static let loadInitialData = "trying to load the initial active state for the app."
            }
        }
    }
}

extension DSCopy {
    enum SettingsView {
        static let biometricsToggle = "Biometrics Enabled"
        static let notificationsToggle = "Notifications Enabled"
        static let dailyRemindersToggle = "Daily Reminders Enabled"
        static let reminderTime = "Daily Reminder Time"
        static let provideFeedback = "Have some feedback for us?"
        static let submitFeedback = "Tell us"
        static let defaultName = "Hey There"
        static let defaultEmail = "No email address on file"
    
        enum Payments {
            static let premiumSubscriberTitle = "Premium Subscriber"
            static let activePrefix = "Active until "
            static let joinedPrefix = "Joined "
            static let manageSubscription = "Manage Subscription →"
            static let nonSubscriberTitle = "Free Plan"
            static let featureDescription1 = "Unlock Premium Features"
            static let featureDescription2 = "• Unlimited journals"
            static let featureDescription3 = "• Prayer tracking"
            static let featureDescription4 = "• Scripture notes"
            static let upgradeSubscription = "Upgrade Now →"
            static let autoRenewOn = "Auto Renew Is On"
            static let autoRenewOff = "Auto Renew Is Off"
            static let subscriptionRenewImage = "arrow.trianglehead.2.counterclockwise.rotate.90"
        }
    }
}
