# Gnosis Copilot Instructions

## Project Overview
Gnosis is a World of Warcraft addon providing highly configurable castbars and timers. It supports multiple WoW versions (Mainline, Classic, BCC, Wrath, Cataclysm, Mists) and uses the Ace3 framework with LibSharedMedia for customization.

## Architecture

### Core Components
- **Gnosis.lua**: Main addon initialization using AceAddon-3.0; sets up libraries and registers with Ace3
- **Bars.lua**: Castbar implementation (~2674 lines); handles creation, positioning, and real-time updates of cast bars
- **Timers.lua**: Swing timers, cooldown tracking, buff/debuff displays (~2420 lines)
- **Callback.lua**: Event handling (~836 lines); processes WoW game events and triggers bar updates
- **Variables.lua**: Event definitions and initialization; declares castbar/timer events for each WoW version
- **Options.lua**: AceConfig UI generation (~2243 lines); creates settings panel for all customizable parameters
- **OptionsFuncs.lua**: Helper functions for option entries (colors, inputs, callbacks)

### Data Model
- **Gnosis.s**: Main settings table (persisted via GnosisDB, GnosisChar, GnosisConfigs)
- **Gnosis.tUnits**: Maps unit IDs (player, target, party1, raid1, arena1, boss1, etc.) to display names
- **Gnosis.castbars**: Runtime castbar instances keyed by unit ID
- **Gnosis.mstimers**: Runtime timer instances keyed by unit ID

### Multi-Version Support Pattern
```lua
-- Example from Callback.lua, Gnosis.lua, etc.
local wowmainline = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE);
local wowclassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC);
local wowbcc = (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC);

-- Conditional API wrapping for deprecated functions
local GetSpellInfo = GetSpellInfo or function(spellID)
  local spellInfo = C_Spell.GetSpellInfo(spellID);
  -- convert and return
end
```
Check WOW_PROJECT_ID constants early; use polyfills for deprecated APIs (GetSpellInfo, GetSpellCooldown, etc.) that moved to C_Spell/C_Item namespaces in newer versions.

### Event-Driven Architecture
- **Event Registration**: Variables.lua defines castbar/misc events per WoW version; Callback.lua registers handlers via Ace3
- **OnUpdate Loop**: Gnosis.xml triggers OnUpdate callback every frame for real-time progress updates
- **Spell Cast Tracking**: UNIT_SPELLCAST_START, UNIT_SPELLCAST_STOP, UNIT_SPELLCAST_CHANNEL_* events update bars immediately

## Key Patterns & Conventions

### Configuration System
- Options are AceConfig/AceConfigRegistry based; use OptCreateBasicTables() to define choice lists
- Color entries use OptColor_Entry() helper; text-based colors use OptColorText_Entry()
- All settings stored in Gnosis.s with structure: `s[category][unit/key][setting]` (e.g., `s.cbconf.player.color`)
- SetBarParams(key, cfgtab, bartab) applies setting changes to running bar instances immediately

### Library Integration
- **LibStub**: Central dependency manager; loaded in Gnosis.lua
- **Ace3**: AceAddon-3.0, AceConsole-3.0, AceEvent-3.0, AceGUI-3.0, AceDB-3.0, AceComm-3.0, AceConfig-3.0
- **LibSharedMedia-3.0**: Registers custom textures/fonts/sounds; retrieved at [Gnosis.lua lines 91-103](Gnosis.lua#L91-L103)
- **LibClassicCasterino/LibClassicDurations**: Classic-only; provides UnitCastingInfo wrappers

### Naming Conventions
- Castbar instances: tbl keys are unit IDs (player, target, arena1, etc.)
- Function prefixes: Opt* for options, Set* for applying settings, Get* for retrieval
- Event handlers: Function named by UNIT_* event (e.g., OnUnitCastingStart)
- Local API caching: Functions like GetSpellInfo cached as local variables at top of files for performance

### Localization Pattern
- Gnosis.L table populated per locale in Locale.lua using @localization directives
- Supported: enUS, deDE, frFR, koKR, ruRU, zhCN, zhTW
- Locale selection stored in Gnosis.s.strLocale

## Critical Workflows

### Adding a New Bar Type or Unit
1. Define unit in Gnosis.tUnits (Options.lua)
2. Add event list to Variables.lua for relevant WoW versions
3. Register events in Callback.lua
4. Create bar update logic in Bars.lua/Timers.lua
5. Add configuration options in Options.lua referencing the unit

### Modifying Bar Rendering
- Bar creation happens in Bars.lua via CreateCastbar() or CreateTimers()
- Real-time updates in Callback.lua event handlers call Gnosis:SetBarParams() to apply settings
- Positions anchored via Gnosis.SetAnchorLocations()

### Debugging Multi-Version Issues
- Use WoW_PROJECT_ID checks; inspect function availability with conditional polyfills
- Test in target WoW version to verify API exists
- Classic versions use LibClassicCasterino wrappers for casting info

## Dependencies & Notes
- Requires Ace3 library suite and LibSharedMedia for full functionality
- SavedVariables: GnosisDB (account-wide), GnosisChar (per-character)
- LoadOnDemand: 0 (always loads immediately)
- Known Issue (Cataclysm): LibDialog-1.0 broken; StaticPopup_DisplayedFrames is no longer public
