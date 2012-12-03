require_dependency "dnu/sanitize"
require_dependency "dnu/sanitizer"
require_dependency "dnu/fight"
require_dependency "dnu/event"

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend DNU::Sanitizer
end

if defined?(ActiveForm)
  ActiveForm.extend DNU::Sanitizer
end
