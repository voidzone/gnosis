Gnosis.LSet = {
	["default"] = "default (English)",
	["deDE"] = "deDE (Deutsch)",
	["frFR"] = "frFR (Français)",
	["koKR"] = "koKR (한국어/조선말)",
	["ruRU"] = "ruRU (русский язык)",
	["zhCN"] = "zhCN (简体中文)",
	["zhTW"] = "zhTW (繁体中文)",
}

function Gnosis:SetupLocale()
Gnosis.L = nil;
Gnosis.L = {};

if (self.s.strLocale == "deDE") then
-- deDE locale (german)
--@localization(locale="deDE", format="lua_additive_table", handle-unlocalized="english", table-name="Gnosis.L")@
elseif (self.s.strLocale == "zhCN") then
-- zhCN locale (simplified chinese)
--@localization(locale="zhCN", format="lua_additive_table", handle-unlocalized="english", table-name="Gnosis.L")@
elseif (self.s.strLocale == "zhTW") then
-- zhTW locale (traditional chinese)
--@localization(locale="zhTW", format="lua_additive_table", handle-unlocalized="english", table-name="Gnosis.L")@
elseif (self.s.strLocale == "koKR") then
-- zhTW locale (traditional chinese)
--@localization(locale="koKR", format="lua_additive_table", handle-unlocalized="english", table-name="Gnosis.L")@
elseif (self.s.strLocale == "ruRU") then
-- ruRU locale (russian)
--@localization(locale="ruRU", format="lua_additive_table", handle-unlocalized="english", table-name="Gnosis.L")@
elseif (self.s.strLocale == "frFR") then
-- frFR locale (french)
--@localization(locale="frFR", format="lua_additive_table", handle-unlocalized="english", table-name="Gnosis.L")@
else
-- default locale (english)
--@localization(locale="enUS", format="lua_additive_table", handle-unlocalized="english", table-name="Gnosis.L")@
end
end
