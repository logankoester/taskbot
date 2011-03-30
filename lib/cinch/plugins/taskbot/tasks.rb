module Cinch
  module Plugins
    module TaskBot
      class Tasks
        include Cinch::Plugin

        match /add "(.+)"/, :method => :add_task
        match /add (.+) "(.+)"/, :method => :add_task_for

        match /(complete|finish) #(\d+)/, :method => :complete_task
        match /(rm|delete|remove) #(\d+)/, :method => :remove_task

        match /list$/, :method => :get_list
        match /list (.+)/, :method => :get_list_for

        match /help$/, :method => :help

        listen_to :channel
        prefix /^!task /

        def initialize(*args)
          super
        end

        def help(m)
          m.reply "Simple to-do lists implemented as an IRC robot"

          m.reply "!task add \"Take out the trash\" - Add a task for yourself"
          m.reply "!task add <nick> \"Take out the trash\" - Add a task for <nick>"

          m.reply "!task complete|finish #<task_id> - Mark a task completed"
          m.reply "!task rm|delete|remove #<task_id> - Remove a task"

          m.reply "!task list - Get a list of your uncompleted tasks"
          m.reply "!task list <nick> - Get a list of <nick>'s uncompleted tasks"

          m.reply "Author: Logan Koester <logan@logankoester.com>"
          m.reply "Fork me at https://github.com/logankoester/taskbot>"
        end

        # Add a task for yourself
        def add_task(m, content)
          add_task_for_user(m, m.user.nick, content)
        end
        
        # Add a task for <nick>
        def add_task_for(m, nick, content)
          add_task_for_user(m, nick, content)
        end

        # Mark a task completed
        def complete_task(m, cmd_alias, task_id2)
          set_task_status(m, task_id2.to_i, :completed)
        end
        
        # Remove a task
        def remove_task(m, cmd_alias, task_id2)
          task = Task.find_by_id2(task_id2.to_i)
          if task
            task.destroy
            m.reply "Task ##{task_id2} has been removed."
          else
            m.reply "Task ##{task_id2} not found."
          end
        end

        # Get a list of your uncompleted tasks
        def get_list(m)
          get_list_for_user(m, m.user.nick)
        end

        # Get a list of <nick>'s uncompleted tasks
        def get_list_for(m, nick)
          get_list_for_user(m, nick)
        end

      private
        def add_task_for_user(m, nick, content)
          nick.downcase!
          user = User.find_by_nick(nick)
          user_status = (user.nil?) ? "New user '#{nick}' created" : "Existing user '#{nick}' found"
          user ||= User.create( :nick => nick )
          task = user.tasks.create( :content => content )
          m.reply "#{user_status}, task added as ##{task.id2}"
          return task
        end

        def get_list_for_user(m, nick)
          nick.downcase!
          user = User.find_by_nick(nick)
          user_status = (user.nil?) ? "New user '#{nick}' created" : "Existing user '#{nick}' found"
          user ||= User.create( :nick => nick )
          open_tasks = user.tasks.select { |t| t if t.status == :open }
          if open_tasks.empty?
            m.reply "#{user_status}, no open tasks."
          else
            m.reply "#{user_status}, open tasks:"
            open_tasks.sort_by { |t| t.id2 }.each do |t| 
              m.reply "##{t.id2} #{t.content}"
            end
          end
        end

        def set_task_status(m, task_id2, new_status)
          task = Task.find_by_id2(task_id2.to_i)
          if task
            old_status = task.status
            task.status = new_status
            task.save
            m.reply "Task ##{task.id2} status changed from #{old_status} to #{task.status}"
          else
            m.reply "Task ##{task.id2} not found."
          end
        end

      end
    end
  end
end
