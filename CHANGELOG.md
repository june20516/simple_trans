# Change Log

## v 0.1.0
- (2019-05-23) Init
   - Basic features running on. (getter, setter, helper, rake task for legacy)

## v 0.2.0
- (2019-05-23) Add new feature
   - Make load Locale whitelist from `ENV['SIMPLE_TRANS_LOCALES']`.
   - Default whitelist `[:en]`.
   - Different setting for each `translate_column` is also support. As below:
       ```ruby
       # Defined method
       # => translate_column(name, locales = default_locales)
  
       # Example
       class Post < ApplicationRecord
         translate_column :title, [:ko, :en, :vn, :th]
         
         ...
       end
       ```
   - !NOTE: Default locale whitelist **must contain all of each column locale** on application scope.
