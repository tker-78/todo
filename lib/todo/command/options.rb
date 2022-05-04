require 'optparse'

module Todo
  class Command
    module Options
      def self.parse!(argv)
        options = {}

        sub_command_parsers = Hash.new do |k, v|
          raise ArgumentError, "'#{v}' is not todo sub command"
        end

        sub_command_parsers['create'] = OptionParser.new do |opt|
          opt.on('-n VAL', '--name=VAL', 'task name') { |v| options[:name] = v }
          opt.on('-c VAL', '--content=VAL', 'task content') { |v| options[:content] = v }
        end

        sub_command_parsers['list'] = OptionParser.new do |opt|
          opt.on('-s VAL', '--status=VAL', 'list status') { |v| options[:status] = v }
        end

        sub_command_parsers['update'] = OptionParser.new do |opt|
          opt.on('-n VAL', '--name=VAL', 'update name') { |v| options[:name] = v }
          opt.on('-c VAL', '--content=VAL', 'update content') { |v| options[:content] = v }
          opt.on('-s VAL', '--status=VAL', 'update status') { |v| options[:status] = v }
        end

        command_parser = OptionParser.new do |opt|
          opt.on_head('-v', '--version', 'Show program version') do |v|
            opt.version = Todo::VERSION
            puts opt.ver
            exit
          end
        end

        begin
          command_parser.order!(argv)
          options[:command] = argv.shift
          sub_command_parsers[options[:command]].parse!(argv)
        rescue OptionParser::MissinfArgument, OptionParser::InvalidOption, ArgumentError => e
          abort e.message

        end

        options
      end
    end
  end
end