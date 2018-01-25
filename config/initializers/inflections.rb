# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end

# Got these rules from this site:
# https://image.slidesharecdn.com/i18n-091229080027-phpapp01/95/advanced-internationalization-with-rails-27-728.jpg?cb=1262073635
# Thanks internet :)
ActiveSupport::Inflector.inflections(:es) do |inflect|
  inflect.plural(/$/, 's')
  inflect.plural(/([^aeioué])$/, '\1es')
  inflect.plural(/([aeiou]s)$/, '\1')
  inflect.plural(/z$/, 'ces')
  inflect.plural(/á([sn])$/, 'a\1es')
  inflect.plural(/í([sn])$/, 'i\1es')
  inflect.plural(/ó([sn])$/, 'o\1es')
  inflect.plural(/ú([sn])$/, 'u\1es')
  inflect.singular(/s$/, '')
  inflect.singular(/es$/, '')
  inflect.irregular('papá', 'papás')
  inflect.irregular('mamá', 'mamás')
  inflect.irregular('sofá', 'sofás')
end
