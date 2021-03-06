require 'optparse'

module Todo
  class Command
    module Options

      # コマンドライン引数を解析して、ハッシュ形式のoptionsを返す
      def self.parse!(argv)
        options = {}


        # サブコマンドのパーサー群
        sub_command_parsers = Hash.new do |k, v|
          # サブコマンドに登録していないコマンドライン引数を受け取った場合、メッセージを返す
          raise ArgumentError, "'#{v}' is not todo sub command"
        end

        sub_command_parsers['create'] = OptionParser.new do |opt|
          opt.banner = 'Usage: create <args>'
          opt.on('-n VAL', '--name=VAL', 'task name') { |v| options[:name] = v }
          opt.on('-c VAL', '--content=VAL', 'task content') { |v| options[:content] = v }
          opt.on_tail('-h', '--help', 'Show this message') { |v| help_sub_command(opt) }
        end

        sub_command_parsers['list'] = OptionParser.new do |opt|
          opt.banner = 'Usage: list <argv>'
          opt.on('-s VAL', '--status=VAL', 'list status') { |v| options[:status] = v }
          opt.on_tail('-h', '--help', 'Show this message') { |v| help_sub_command(opt) }
        end

        sub_command_parsers['update'] = OptionParser.new do |opt|
          opt.banner = 'Usage: update <argv>'
          opt.on('-n VAL', '--name=VAL', 'update name') { |v| options[:name] = v }
          opt.on('-c VAL', '--content=VAL', 'update content') { |v| options[:content] = v }
          opt.on('-s VAL', '--status=VAL', 'update status') { |v| options[:status] = v }
          opt.on_tail('-h', '--help', 'Show this message') { |v| help_sub_command(opt) }
        end

        sub_command_parsers['delete'] = OptionParser.new do |opt|
          opt.banner = 'Usage: delete id'
          opt.on_tail('-h', '--help', "Show this message") { |v| help_sub_command(opt) }
        end

        def self.help_sub_command(parser)
          puts parser.help
          exit
        end

        # コマンドのパーサー群
        command_parser = OptionParser.new do |opt|
          opt.on_head('-v', '--version', 'Show program version') do |v|
            opt.version = Todo::VERSION
            puts opt.ver
            exit
          end
          sub_command_help = [
            {name: 'create -n name -c content', summary: 'Create Todo Task'},
            {name: 'update id -n name -c content -s status', summary: 'Update Todo Task'},
            {name: 'list -s status', summary: 'List Todo Task'},
            {name: 'delete id', summary: 'Delete Todo Task'}
          ]

          opt.banner = "Usage: #{opt.program_name} [-h|--help][-v|--version] <command> [<args>]"
          opt.separator ''
          opt.separator "#{opt.program_name} Avairable Commands:"
          sub_command_help.each do |command|
            opt.separator [opt.summary_indent, command[:name].ljust(40), command[:summary]].join(' ')
          end

          opt.on_head('-h', '--help', 'Show this message') do |v|
            puts opt.help
            exit
          end
        end

        begin
          command_parser.order!(argv)
          options[:command] = argv.shift
          sub_command_parsers[options[:command]].parse!(argv)

          # updateとdeleteの場合はidを取得する
          if %w(update delete).include?(options[:command])
            raise ArgumentError, "#{options[:command]} id not found." if argv.empty?
            options[:id] = Integer(argv.first)
          end
        rescue OptionParser::MissingArgument, OptionParser::InvalidOption, ArgumentError => e
          abort e.message
        end

        options
      end
    end
  end
end