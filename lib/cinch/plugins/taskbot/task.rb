module Cinch
  module Plugins
    module TaskBot

      class Task
        include MongoMapper::Document
        key :content, String
        key :status, Symbol, :default => :open
        belongs_to :user
      end

    end
  end
end
