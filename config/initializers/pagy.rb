require 'pagy/extras/semantic'
require 'pagy/extras/bootstrap'

Pagy::DEFAULT[:items] = 10 # items per page
Pagy::DEFAULT[:size]  = [1, 4, 4, 1] # nav bar links
# Better user experience handled automatically
require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :last_page