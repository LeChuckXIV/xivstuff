-- Setup Requirements
-- Requires YesAlready installed
-- both leve npcs in the talk section
-- journal result complete needs to be disabled


-- Initialisation
amount = 93 -- loop amount
ec = false -- error checking
key_confirm = "numpad0" -- default: numpad0
key_submenu = "multiply" -- default: multiply
key_escape = "escape" -- default: escape

-- Start Macro
for i = 1, amount, 1 do
  attempts = 1
  max_attempts = 10

  -- Start action bar 1 error checking
  ::action_bar1::
  if IsAddonReady("_ActionBar") and IsAddonVisible("_ActionBar") then
    yield('/waitaddon _ActionBar' )
    yield('/target Grigge' )
    yield('/send ' .. key_confirm )
  else
    yield('/wait 0.5' )
    goto action_bar1
  end
  -- End action bar 1 error checking

  -- Start tradecraft error checking
  ::click_tradecraft::
  if IsAddonReady("SelectString") and IsAddonVisible("SelectString") and string.find(GetSelectStringText(1), "Tradecraft") then
    yield('/waitaddon "SelectString"' )
    yield('/click select_string2' )
    attempts = 1
  else    
    yield('/wait 0.5' )
    if attempts > max_attempts then
      yield('/echo Macro Ended - Failure' )
      return
    else
      if ec then yield('/echo click failed attempt: ' .. attempts .. ', waiting' ) end
      attempts = attempts + 1
      goto click_tradecraft
    end
  end
  -- End tradecraft error checking

  -- Start guildleve error checking
  ::GuildLeveCheck::
  if IsAddonReady("GuildLeve") and IsAddonVisible("GuildLeve") then
    yield('/waitaddon GuildLeve' )
    yield('/click journal_detail_accept' )
    yield('/wait 0.5' )
    yield('/send ' .. key_escape )
    attempts = 1 
  else
    yield('/wait 0.5' )
    if attempts > max_attempts then
      yield('/echo Macro Ended - Failure' )
      return
    else
      if ec then yield('/echo guild leve accept failed attempt: ' .. attempts .. ', waiting' ) end
      attempts = attempts + 1
      goto GuildLeveCheck
    end
  end
  -- End guildleve error checking

  -- Start select string error checking
  ::exit_grigge::
  if IsAddonReady("SelectString") and IsAddonVisible("SelectString") and string.find(GetSelectStringText(1), "Tradecraft") then
    yield('/waitaddon SelectString' )
    yield('/click select_string4' )
    attempts = 1
  else
    yield('/wait 0.5')
    if attempts > max_attempts then
      yield('/echo Macro Ended - Failure' )
      return
    else
      if ec then yield('/echo exit select string accept failed attempt: ' .. attempts .. ', waiting' ) end
      attempts = attempts + 1
      goto exit_grigge
    end
  end
  -- End select string error checking

  -- Start action bar 2 error checking
  ::action_bar2::
  if IsAddonReady("_ActionBar") and IsAddonVisible("_ActionBar") then
    yield('/waitaddon "_ActionBar"' )
    yield('/target Ahldiyrn' )
    yield('/send ' .. key_confirm )
  else
    yield('/wait 0.5' )
    goto action_bar2
  end
  -- End action bar 2 error checking

  -- Start practical command error checking
  ::click_practical_command::
  if IsAddonReady("SelectIconString") and IsAddonVisible("SelectIconString") and string.find(GetSelectIconStringText(1), "Practical") then
    yield('/waitaddon "SelectIconString"' )
    yield('/click select_icon_string2' )
    attempts = 1
  else    
    yield('/wait 0.5' )
    if attempts > max_attempts then
      yield('/echo Macro Ended - Failure' )
      return
    else
      if ec then yield('/echo click practical failed attempt: ' .. attempts .. ', waiting' ) end
      attempts = attempts + 1
      goto click_practical_command
    end
  end
  -- End practical command error checking

  -- Start hand over process
  ::send_multiply::
  if IsAddonReady("Request") and IsAddonVisible("Request") then
    yield('/waitaddon "Request"' )
  
    yield('/send ' .. key_submenu )
    yield('/wait 0.2' )

    ::select_item::
    if IsAddonReady("ContextIconMenu") and IsAddonVisible("ContextIconMenu") then
      yield('/waitaddon "ContextIconMenu"' )
      yield('/send ' .. key_confirm )
      yield('/wait 0.2' )
      ::hand_over::
      if not (IsAddonReady("ContextIconMenu") and IsAddonVisible("ContextIconMenu")) then
        yield('/click request_hand_over' )
      else
        yield('/wait 0.5' )
        if attempts > max_attempts then
          yield('/echo Macro Ended - Failure' )
          return
        else
          if ec then yield('/echo hand over failed attempt: ' .. attempts .. ', waiting' ) end
          attempts = attempts + 1
          goto hand_over
        end
      end    
    else
      yield('/wait 0.5' )
      if attempts > max_attempts then
        yield('/echo Macro Ended - Failure' )
        return
      else
        if ec then yield('/echo select practical failed attempt: ' .. attempts .. ', waiting' ) end
        attempts = attempts + 1
        goto send_multiply
      end
    end
  else 
    yield('/wait 0.5' )
    if attempts > max_attempts then
      yield('/echo Macro Ended - Failure' )
      return
    else
      if ec then yield('/echo context menu failed attempt: ' .. attempts .. ', waiting' ) end
      attempts = attempts + 1
      goto send_multiply 
    end
  end
  -- End hand over process

  -- Start journal error checking
  ::complete_leve::
  if IsAddonReady("JournalResult") and IsAddonVisible("JournalResult") then
    yield('/waitaddon "JournalResult"' )
    yield('/click journal_result_complete' )
  else
    yield('/wait 0.5' )
    if attempts > max_attempts then
      yield('/echo Macro Ended - Failure' )
      return
    else
      if ec then yield('/echo journal result failed attempt: ' .. attempts .. ', waiting' ) end
      attempts = attempts + 1
      goto complete_leve
    end
  end
  -- End journal error checking

  -- Start action bar 3 error checking
  ::action_bar3::
  if IsAddonReady("_ActionBar") and IsAddonVisible("_ActionBar") then
    yield ('/echo Leve ' .. i .. ' complete, looping. Remaing: ' .. (amount - i) )
  else
    yield('/wait 0.5' )
    goto action_bar3
  end
  -- End action bar 3 error checking
end
--End Macro