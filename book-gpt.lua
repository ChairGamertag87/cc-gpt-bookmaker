
local proxyUrl = "http://YOUR_PROXY_IP/generate"
local prompt = "your prompt"
local title = "book title"
local filename = "livre.txt"
local favoritesFile = "book_favorites.txt"
local pastebinOutput = "pastebin_temp.txt"

local function urlEncode(str)
  str = str:gsub("\n", " ")
  str = str:gsub("([^%w%-_%.~])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
  return str
end

print("Envoi du prompt au proxy GPT...")
local encodedPrompt = urlEncode(prompt)
local fullUrl = proxyUrl .. "?prompt=" .. encodedPrompt
local response = http.get(fullUrl)

if not response then
  print("Erreur : proxy GPT inaccessible.")
  return
end

local content = response.readAll()
response.close()

local file = fs.open(filename, "w")
file.write(content)
file.close()
print(" Texte sauvegardé localement.")

print("Upload vers Pastebin...")

local originalTerm = term.current()
local output = {}
local fakeTerm = {
    write = function(str) table.insert(output, str) end,
    scroll = function() end,
    setCursorPos = function() end,
    setCursorBlink = function() end,
    getCursorPos = function() return 1, 1 end,
    getSize = function() return 51, 19 end,
    isColour = function() return false end,
    isColor = function() return false end,
    clear = function() end,
    blit = function(text, textCol, backCol) table.insert(output, text) end,
    setTextColor = function() end,
    setBackgroundColor = function() end,
    getTextColor = function() return colors.white end,
    getBackgroundColor = function() return colors.black end,
  }
term.redirect(fakeTerm)

shell.run("pastebin", "put", filename)

term.redirect(originalTerm)

local pastebinOutput = table.concat(output, "")
local pastebinLink = pastebinOutput:match("https://pastebin.com/%w%w%w%w%w%w%w%w")

if not pastebinLink then
  print("❌ Erreur : lien Pastebin non trouvé.")
  return
end

local fav = fs.open(favoritesFile, "a")
fav.writeLine("{")
fav.writeLine('  title = "' .. title .. '",')
fav.writeLine('  link = "' .. pastebinLink .. '",')
fav.writeLine("},")
fav.close()

print("✅ Lien enregistré dans '" .. favoritesFile .. "' : " .. pastebinLink)