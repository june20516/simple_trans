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

- (2019-05-26 patch 0.2.2) Fixed bug on fetching environment variable (`ENV`).
   - **Problem**:
      - Environment variable usually cannot be fetched not Array but String and it needs to be cascade into Symbol also.
   - **Solved**:
      - Modify fetching env variable method.
      - from `ENV['SIMPLE_TRANS_LOCALES'] || %i[en]`
      - to `ENV.fetch('SIMPLE_TRANS_LOCALES', 'en').split(',').map(&:to_sym)`
