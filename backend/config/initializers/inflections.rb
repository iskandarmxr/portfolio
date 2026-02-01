# Be sure to restart your server when you modify this file.

ActiveSupport::Inflector.inflections(:en) do |inflect|
  # Irregular pluralization
  inflect.irregular "experience", "experiences"
  
  # Uncountable words
  # inflect.uncountable %w( fish sheep )
end
