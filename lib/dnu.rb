require_dependency "dnu/deep_clone"
require_dependency "dnu/serif_parser"
require_dependency "dnu/sanitize"
require_dependency "dnu/sanitizer"
require_dependency "dnu/map_gsub"
require_dependency "dnu/fight"
require_dependency "dnu/event"
require_dependency "dnu/process"

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend DNU::Sanitizer
end

if defined?(ActiveForm)
  ActiveForm.extend DNU::Sanitizer
end

if defined?(Tx::Map)
  Tx::Map.send :include, DNU::MapGsub
end
