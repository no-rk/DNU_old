require_dependency "dnu/deep_clone"
require_dependency "dnu/data"
require_dependency "dnu/generate_map"
require_dependency "dnu/text"
require_dependency "dnu/map_gsub"
require_dependency "dnu/fight"
require_dependency "dnu/event"
require_dependency "dnu/process"

if defined?(Tx::Map)
  Tx::Map.send :include, DNU::MapGsub
end
