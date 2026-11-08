# Changelog

All notable changes to **Factionizer** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [7.0.0] - Unreleased

### Added
- **Visual Reputation Progress Bar in Chat (`Core/Reputation.lua`, `GUI/Options.lua`, `Locales/`)**:
  - Added a visual 20-segment chat progress line on reputation changes (e.g., `Der Hohe Orden: +10 (0.2%) - 40% bis Wohlwollend: [||||||||............]`) showing delta, percentage gain, overall standing percentage, colored target standing name, and `[||||...]` progress bar.
  - Supports standard standings (`Hated` through `Exalted`), Retail Major Factions (`Renown`), Friendship factions, and `Paragon` reward bars.
  - Configurable via **Chat & Rep Bar -> Show visual reputation progress bar in chat** (`ShowProgressChat`, enabled by default).
- **Multi-Client & Cross-Expansion Support**: Full compatibility across **Retail (12.x Midnight & 11.x The War Within)**, **Mists of Pandaria Classic (5.5.x)**, **Cataclysm Classic (4.4.x)**, **Wrath / Titan Reforged Classic (3.4.x / 3.80.x)**, **TBC Anniversary (2.5.x)**, **Classic Era / Season of Discovery (1.15.x)**, and **Classic Forever (16001)**.
- **Complete Reputation Database Across All Expansions (`Data/Content_*.lua`)**:
  - Modularized reputation guides for **Classic**, **Season of Discovery & Classic Forever**, **The Burning Crusade**, **Wrath of the Lich King**, **Cataclysm**, **Mists of Pandaria** (including Tillers & Anglers friendships), **Warlords of Draenor**, **Legion** (including Paragon & Fisherfriends), **Battle for Azeroth**, **Shadowlands** (including Covenants, Ve'nari & Zereth Mortis), **Dragonflight** (Major Renown & Friendships), **The War Within** (Major Renown, Severed Threads Pacts & Undermine Cartels), and **Midnight** (`Silvermoon Court`, `Amani Tribe`, `Haranir`, `The Singularity`).
  - Added support for Timewalking Commendations, World Quests, Elite World Quests, Emissary Quests, Weekly Quests, Contract Bonuses, Covenant Callings, Bountiful Delves, and Special Assignments.
- **Modern Dark-Gold UI (`GUI/UIStyle.lua`, `GUI/DetailFrame.lua`, `GUI/Options.lua`)**:
  - Redesigned **Reputation Detail Frame** (`FIZ_ReputationDetailFrame`, `580x672`) featuring a live StatusBar + Preview Bar (`LibSharedMedia-3.0`), 2-column statistics card (*Needed*, *Current*, *Missing*, *To Exalted*, *In Bags*, *In Bags & Bank*, *In Quests*, *Session Gain*) with vertical divider, interactive proportional filter pills (`Quests`, `Instances`, `Mobs`, `Items`, `General`) with checkmark icons, real-time search box, styled dark-gold scrollbar, and color-coded source badges.
  - Built standalone **Configuration Window** (`FactionizerConfigFrame`) with category sidebar (`General`, `Chat & Rep Bar`, `Reputation Sources`, `Notifications`, `Sharing & Export`, `Profiles`, `About`) and Blizzard AddOn Options integration.
  - Added live **UI Font Size (`10pt – 18pt`)** scaling (`A-` | `13pt` | `A+` header buttons and option slider) with automatic layout reflow (`FIZ:LayoutDetailFrameControls()`) and fixed-width multi-button row support (`btn:SetFixedWidth(w)`).
- **Minimap Button, Interactive `LibQTip-1.0` Tooltip & Addon Compartment (`GUI/Minimap.lua`)**:
  - Added **`LibDataBroker-1.1`** feed, **`LibDBIcon-1.0`** minimap button, and Blizzard **Addon Compartment** integration.
  - Added interactive 5-column **`LibQTip-1.0`** tooltip (*Faction*, *Standing*, *Current Reputation* with embedded `StatusBar` progress bars, *Missing*, *Session*) with Left-Click to open faction details and Right-Click to watch a faction.
- **Extended Ace3 & Library Ecosystem**:
  - Migrated core architecture to **Ace3** (`AceAddon-3.0`, `AceEvent-3.0`, `AceTimer-3.0`, `AceBucket-3.0`, `AceHook-3.0`, `AceDB-3.0`, `AceDBOptions-3.0`, `AceLocale-3.0`, `AceConsole-3.0`, `AceGUI-3.0`, `AceConfig-3.0`, `AceComm-3.0`, `AceTab-3.0`, `AceSerializer-3.0`).
  - Added **`HereBeDragons-2.0`** for automatic 410-zone localization across all expansions.
  - Added **`LibWindow-1.1`** for persistent window positions, `Ctrl + MouseWheel` scaling, and Dock/Detach mode on the Detail Frame.
  - Added **`LibSink-2.0`** for customizable reputation gain output routing (Chat, Floating Combat Text, UIErrorsFrame, RaidWarning, MSBT, Parrot, SCT, or Muted).
  - Added **`LibDeflate`** for compressed profile & quest exclusion import/export strings (`!FIZ1!...`) and party/raid/guild syncing.

### Changed
- Reorganized the entire codebase into modular `Data/`, `Core/`, `GUI/`, and `Locales/` directories.
- Migrated all saved settings and quest exclusions into `FactionizerDB` (`AceDB-3.0`) with automatic migration from legacy `FIZ_Data` and `FIZ_Suppressed`.
- Migrated all 11 supported locales (`enUS`, `deDE`, `frFR`, `esES`, `esMX`, `itIT`, `koKR`, `ptBR`, `ruRU`, `zhCN`, `zhTW`) to `AceLocale-3.0` with complete `enUS`/`deDE` translation coverage and localized item/quest fallbacks for uncached Classic/TBC/Wrath IDs.
- Anchored `FIZ_OptionsButton` and `FIZ_OrderByStandingCheckBox` directly above `ReputationListScrollFrame` (`FIZ:PositionReputationFrameControls()`) so they stay aligned with the reputation list even when the right-hand Character Stats pane is expanded.
- Upgraded `LSM30_Statusbar` dropdown menu with a Modern Dark-Gold frame, `SetClipsChildren(true)` scroll clipping, `256px` max height, and a dark text scrim for high-contrast readability across bright statusbar textures.

### Fixed
- Fixed cross-version reputation API compatibility for Retail's `C_Reputation`, `C_MajorFactions` (Renown), `C_Reputation.GetFactionParagonInfo` (Paragon), and `C_GossipInfo.GetFriendshipReputation` alongside Classic's `GetFactionInfo` and `ReputationFrame_SetRowType`.
- Fixed reputation preview bar calculation (`FIZ:GetReadyReputation`) for items in bags/bank and completed quests in the quest log.
- Fixed colliding legacy map IDs, capital city Commendation Badge lookups, and tabard championing detection across WotLK and Cataclysm dungeons.
- Fixed missing close button (`UI-StopButton`) and checkbox checkmark (`UI-CheckBox-Check`) icons when running alongside `ElvUI` / `AddOnSkins` or custom UI fonts.
- Fixed button and filter pill overflow in `FIZ_ReputationDetailFrame` header, filter bar, and footer when using German localization and scaled fonts.

### Removed
- Removed legacy monolithic root files (`Factionizer.lua`, `Factionizer.xml`, `content.lua`, `mapping.lua`, `locale.xml`) and obsolete XML option/detail frames.
