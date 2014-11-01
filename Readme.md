# Fron
[![Code Climate](https://codeclimate.com/github/digitalnatives/fron/badges/gpa.svg)](https://codeclimate.com/github/digitalnatives/fron)

# Rake Tasks
```
rake build                       # Build fron-0.1.4.gem into the pkg directory
rake ci                          # Run continous integation tasks
rake documentation:coverage      # Check documentation coverage
rake documentation:generate      # Generate documentation
rake install                     # Build and install fron-0.1.4.gem into system gems
rake opal:rspec                  # Run opal specs in phantomjs
rake opal:rspec:coverage         # Check opal specs coverage
rake opal:rspec:coverage:runner  # Run opal specs in phantomjs
rake release                     # Create tag v0.1.4 and build and push fron-0.1.4.gem to Rubygems
rake rubycritic:coverage         # Check Rubycritic coverage
rake rubycritic:generate         # Generates Rubycritic report
rake syntax:ruby                 # Run a Ruby syntax check
```
