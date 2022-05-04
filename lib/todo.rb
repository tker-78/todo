# frozen_string_literal: true

require_relative "todo/version"
require_relative "todo/command"
require_relative "todo/db"
require_relative "todo/task"
require_relative "todo/command/options"

module Todo
  class Error < StandardError; end
  # Your code goes here...
end
