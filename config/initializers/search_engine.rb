require 'lib/search_engine'
SearchEngine.kind = SETTINGS["search_engine"]

# Mention everything to ensure that rails eager loading doesn't get the better of us
Person
Company
Project
Group
ResourceLink
