module Cinch
  module Plugins
    module TaskBot
      autoload :Task, File.expand_path('../taskbot/task', __FILE__)
      autoload :User, File.expand_path('../taskbot/user', __FILE__)
      autoload :Tasks, File.expand_path('../taskbot/tasks', __FILE__)
    end
  end
end
