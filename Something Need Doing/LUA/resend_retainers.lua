-- Initialisation
key_confirm = "numpad0"
retainer_amount = 10

-- Start Retainer Loop Function
function resend_retainers()
  for currentRetainer = 1 , retainer_amount, 1 do
    yield('/waitaddon "RetainerList"')
    yield('/click select_retainer' .. currentRetainer )
    yield('/waitaddon "SelectString" ')
    yield('/click select_string6 ')
    yield('/waitaddon "RetainerTaskResult" ')
    yield('/click retainer_venture_result_reassign ')
    yield('/waitaddon "RetainerTaskAsk" ')
    yield('/click retainer_venture_ask_assign ')
    yield('/waitaddon "SelectString" ')
    yield('/click select_string11' )
  end
end
-- End Retainer loop function

resend_retainers()