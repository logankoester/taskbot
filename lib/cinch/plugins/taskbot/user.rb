module Cinch
  module Plugins
    module TaskBot

      class User
        include MongoMapper::Document
        key :nick, String
        many :tasks, :class => Cinch::Plugins::TaskBot::Task
      end

    end
  end
end
