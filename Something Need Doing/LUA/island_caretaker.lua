-- Setup Instructions
-- Stand next to crop or animal NPC
-- Set jobType below to swap NPC

-- Set Keybinds here
key_confirm = "numpad0"
key_right = "numpad6"
key_context = "multiply"
key_down = "numpad2"
key_escape = "escape"

-- set for different npc
jobType = "Animal" -- Animal or Crop











-- Code begins here, don't edit unless you know what you're doing

animal_npc = "Creature Comforter"
animal_window = "MJIAnimalManagement"
crop_npc = "Produce Producer"
crop_window = "MJIFarmManagement"

if (jobType == "Animal") then
  npc_type = animal_npc
  window_type = animal_window
elseif (jobType == "Crop") then
  npc_type = crop_npc
  window_type = crop_window
else 
  yield('/echo wrong npc type')
  return
end

-- Start Caretaker Loop Function
function fetch_supplies()
  yield('/target ' .. npc_type)
  yield('/send ' .. key_confirm)
  yield('/waitaddon SelectString')
  yield('/click select_string1')
  yield('/waitaddon ' .. window_type)
  yield('/send ' .. key_right)
  for currentItem = 1 , 20, 1 do
    yield('/send ' .. key_context)
    yield('/waitaddon ContextMenu')
    if (jobType == "Animal") then
      yield('/send ' .. key_down)
      yield('/send ' .. key_down)
    end
    if (jobType == "Crop") then
      yield('/send ' .. key_down)
    end
    yield('/send ' .. key_confirm)
    yield('/waitaddon SelectYesno')
    yield('/click select_yes')
    yield('/wait 0.5') -- Can be increased for ping
    yield('/send ' .. key_down)    
  end
  yield('/send ' .. key_escape)
  yield('/echo ' .. jobType .. ' Caretaker Collection Done')
end
-- End Caretaker loop function

fetch_supplies()