//
//  Settings.swift
//  CodeEditModules/Settings
//
//  Created by Lukas Pistrol on 01.04.22.
//

import SwiftUI
import Foundation

/// # Settings
///
/// The model structure of settings for `CodeEdit`
///
/// A `JSON` representation is persisted in `~/Library/Application Support/CodeEdit/preference.json`.
/// - Attention: Don't use `UserDefaults` for persisting user accessible settings.
///  If a further setting is needed, extend the struct like ``GeneralSettings``,
///  ``ThemeSettings``,  or ``TerminalSettings`` does.
///
/// - Note: Also make sure to implement the ``init(from:)`` initializer, decoding
///  all properties with
///  [`decodeIfPresent`](https://developer.apple.com/documentation/swift/keyeddecodingcontainer/2921389-decodeifpresent)
///  and providing a default value. Otherwise all settings get overridden.
struct SettingsData: Codable, Hashable {

    /// The general global settings
    var general: GeneralSettings = .init()

    /// The global settings for accounts
    var accounts: AccountsSettings = .init()

    /// The global settings for themes
    var theme: ThemeSettings = .init()

    /// The global settings for text editing
    var textEditing: TextEditingSettings = .init()

    /// The global settings for the terminal emulator
    var terminal: TerminalSettings = .init()

    /// The global settings for source control
    var sourceControl: SourceControlSettings = .init()

    /// The global settings for keybindings
    var keybindings: KeybindingsSettings = .init()

    /// Feature Flags settings
    var featureFlags: FeatureFlagsSettings = .init()

    /// Searh Settings
    var search: SearchSettings = .init()

    /// Default initializer
    init() {}

    /// Explicit decoder init for setting default values when key is not present in `JSON`
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.general = try container.decodeIfPresent(GeneralSettings.self, forKey: .general) ?? .init()
        self.accounts = try container.decodeIfPresent(AccountsSettings.self, forKey: .accounts) ?? .init()
        self.theme = try container.decodeIfPresent(ThemeSettings.self, forKey: .theme) ?? .init()
        self.terminal = try container.decodeIfPresent(TerminalSettings.self, forKey: .terminal) ?? .init()
        self.textEditing = try container.decodeIfPresent(TextEditingSettings.self, forKey: .textEditing) ?? .init()
        self.search = try container.decodeIfPresent(SearchSettings.self, forKey: .search) ?? .init()
        self.sourceControl = try container.decodeIfPresent(
            SourceControlSettings.self,
            forKey: .sourceControl
        ) ?? .init()
        self.keybindings = try container.decodeIfPresent(
            KeybindingsSettings.self,
            forKey: .keybindings
        ) ?? .init()
        self.featureFlags = try container.decodeIfPresent(FeatureFlagsSettings.self, forKey: .featureFlags) ?? .init()
    }

    // swiftlint:disable cyclomatic_complexity
    func propertiesOf(_ name: SettingsPage.Name) -> [SettingsPage] {
        var settings: [SettingsPage] = []

        switch name {
        case .general:
            general.searchKeys.forEach { settings.append(.init(name, isSetting: true, settingName: $0)) }
        case .accounts:
            accounts.searchKeys.forEach { settings.append(.init(name, isSetting: true, settingName: $0)) }
        case .theme:
            theme.searchKeys.forEach { settings.append(.init(name, isSetting: true, settingName: $0)) }
        case .textEditing:
            textEditing.searchKeys.forEach { settings.append(.init(name, isSetting: true, settingName: $0)) }
        case .terminal:
            terminal.searchKeys.forEach { settings.append(.init(name, isSetting: true, settingName: $0)) }
        case .search:
            search.searchKeys.forEach { settings.append(.init(name, isSetting: true, settingName: $0)) }
        case .sourceControl:
            sourceControl.searchKeys.forEach { settings.append(.init(name, isSetting: true, settingName: $0)) }
        case .location:
            LocationsSettings().searchKeys.forEach { settings.append(.init(name, isSetting: true, settingName: $0)) }
        case .featureFlags:
            featureFlags.searchKeys.forEach { settings.append(.init(name, isSetting: true, settingName: $0)) }
        case .behavior: return [.init(name, settingName: "Error")]
        case .navigation: return [.init(name, settingName: "Error")]
        case .components: return [.init(name, settingName: "Error")]
        case .keybindings: return [.init(name, settingName: "Error")]
        case .advanced: return [.init(name, settingName: "Error")]
        }

        return settings
    }
    // swiftlint:enable cyclomatic_complexity
}
