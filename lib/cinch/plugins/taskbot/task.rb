module Cinch
  module Plugins
    module TaskBot
      
      # content - String  - Description of the item
      # status  - Symbol  - Typically :open or :completed
      # id2     - Integer - Auto-incrementing numeric key (id uses ObjectId).
      #                     Numeric IDs are easier for users to deal with over IRC.
      class Task
        include MongoMapper::Document
        key :content, String
        key :status, Symbol, :default => :open
        belongs_to :user
        auto_increment!
      end

    end
  end
end
