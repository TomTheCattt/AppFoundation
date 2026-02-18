//
//  IconSet.swift
//  AppFoundation
//
//  Centralized SF Symbol and asset icon names for consistency.
//

import UIKit

enum IconSet {
    // MARK: - Navigation
    enum Navigation {
        static let back = "chevron.left"
        static let close = "xmark"
        static let forward = "chevron.right"
        static let menu = "line.3.horizontal"
    }

    // MARK: - Tabs
    enum Tab {
        static let home = "house"
        static let homeFilled = "house.fill"
        static let search = "magnifyingglass"
        static let profile = "person"
        static let profileFilled = "person.fill"
        static let settings = "gearshape"
        static let settingsFilled = "gearshape.fill"
    }

    // MARK: - Actions
    enum Action {
        static let add = "plus"
        static let delete = "trash"
        static let edit = "pencil"
        static let share = "square.and.arrow.up"
        static let refresh = "arrow.clockwise"
        static let checkmark = "checkmark"
        static let cancel = "xmark.circle"
    }

    // MARK: - Status
    enum Status {
        static let success = "checkmark.circle.fill"
        static let error = "xmark.circle.fill"
        static let warning = "exclamationmark.triangle.fill"
        static let info = "info.circle.fill"
    }

    // MARK: - Content
    enum Content {
        static let empty = "tray"
        static let document = "doc"
        static let image = "photo"
        static let video = "video"
        static let link = "link"
    }
}
