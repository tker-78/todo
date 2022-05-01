module Todo
  class Command
    def execute
      DB.prepare
    end

    def create_task(name, content)
      Task.create!(name: name, content: content).reload
    end
  end
end