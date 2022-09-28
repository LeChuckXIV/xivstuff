-- Create a folder in %appdata%/XIVLauncher/ called recipes
-- Place .txt files in there with your teamcraft recipes or macros
-- Change the recipe below, keep the ""

currentRecipe = "3starFoodPot"  -- Current Recipe
gameRecipe = "Grade 7 Tincture of Strength" -- copy and paste it from in game, right click copy
requireFood = true
requirePot = true
errorChecking = true
loopAmount = 18

--Keybinds
key_food = "O"
key_repair = "OEM_6"
key_spiritbond = "OEM_4"
key_pot = "K"
key_escape = "escape"
key_confirm = "numpad0"


-- Do not edit below unless you know what you're doing --
appdata = os.getenv("appdata")
recipesDir = appdata .. "\\XIVLauncher\\recipes\\"

localfile = recipesDir .. currentRecipe .. ".txt"

function eat()
  if not HasStatus("Well Fed") then
    if IsAddonVisible("RecipeNote") then
      yield('/send ' .. key_escape)
      while IsCrafting() do yield('/wait 0.5') end
    end
    ::foodcheck::
    if not IsAddonVisible("RecipeNote") then
      yield('/send ' .. key_food)
      yield('/wait 2.5')
      if HasStatus("Well Fed") then return else goto foodcheck end
    end
  end
end

function pot()
  if not HasStatus("Medicated") then
    if IsAddonVisible("RecipeNote") then
      yield('/send ' .. key_escape)
      while IsCrafting() do yield('/wait 0.5') end
    end
    ::potcheck::
    if not IsAddonVisible("RecipeNote") then
      yield('/send ' .. key_pot)
      yield('/wait 2.5')
      if HasStatus("Medicated") then return else goto potcheck end
    end
  end
end

function repair()
  ::repair_start::
  if (IsAddonVisible("RecipeNote")) then
    yield('/send ' .. key_escape)
    while (IsCrafting()) do yield('/wait 0.5') end
  end
  if not (IsAddonVisible("RecipeNote")) then
    ::repair_window::
    yield('/send ' .. key_repair)
    yield('/wait 1')
    if IsAddonVisible("Repair") and IsAddonReady("Repair") then
      yield('/click repair_all')
      yield('/waitaddon "SelectYesno"')
      yield('/click select_yes')
      while (NeedsRepair()) do yield('/wait 0.5') end
      while IsAddonVisible("Repair") do 
        yield('/send ' .. key_escape)
        yield('/wait 0.5')
      end
    else goto repair_window end
  else goto repair_start end
end

function spiritbond()
  if (IsAddonVisible("RecipeNote")) then
    yield('/send ' .. key_escape)
    while (IsCrafting()) do yield('/wait 0.5') end
  end
  if not (IsAddonVisible("RecipeNote")) then
    yield('/send ' .. key_spiritbond)
    yield('/waitaddon Materialize')
    while (CanExtractMateria(99)) do
      yield('/send ' .. key_confirm)
      yield('/wait 1')
    end
    if not (CanExtractMateria(99)) then
      if (IsAddonVisible("Materialize")) then
        yield('/send ' .. key_escape)
        yield('/wait 0.5')
      end
    end
  end   
end

function craftRecipe()
  local f = io.open(localfile)
  if not (f~=nil) then  
     if (errorChecking) then yield('/echo File not found at ' .. localfile) end
     return false 
   end
  local output = {}
  local lines = 1
  for each in f:lines() do
    output[#output+1] = each
  end
  local ctr = 0
  for _ in io.lines(localfile) do
    ctr = ctr + 1
  end
  -- final status check
  if (requirePot) then
    if not HasStatus("Medicated") then return end
  end
      
  if (requireFood) then
    if not HasStatus("Well Fed") then return end
  end

  -- Crafting macro
  if not (IsAddonVisible("RecipeNote")) then 
    yield('/recipe "' .. gameRecipe .. '"' )
    while not (IsAddonVisible("RecipeNote") and (IsAddonReady("RecipeNote"))) do yield('/wait 0.5') end
  end
  if (IsAddonVisible("RecipeNote")) and (IsAddonReady("RecipeNote")) then 
    yield('/click Synthesize')
    yield('/waitaddon Synthesis')
  end

  -- Loop contents
  for i = 1, ctr, 1 do
    yield(output[i])
  end
  f:close()

  yield('/waitaddon RecipeNote') 
end

for i = 1, loopAmount, 1 do
  if NeedsRepair() then repair() end
  if CanExtractMateria(99) then spiritbond() end
  if requireFood then eat() end
  if requirePot then pot() end
  craftRecipe()
  yield ('/echo Craft ' .. i .. ' complete, looping. Remaing: ' .. (loopAmount - i) )
end