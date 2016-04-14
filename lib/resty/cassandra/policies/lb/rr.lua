local _rr_lb = require('resty.cassandra.policies.lb').new_policy('round_robin')

function _rr_lb:init(peers)
  self.peers = peers
  self.idx = -2
end

local function next_peer(state, i)
  if i == #state.peers then
    return nil
  end

  state.idx = state.idx + 1

  return i + 1, state.peers[(state.idx % #state.peers) + 1]
end

function _rr_lb:iter()
  local idx = self.idx
  self.idx = idx + 1
  return next_peer, self, 0
end

return _rr_lb
