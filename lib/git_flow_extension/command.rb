require 'optparse'
require 'git_flow_extension'
require 'git_flow_extension/command/common'
require 'git_flow_extension/command/release'

if ARGV.empty? then
  $stderr.puts "no subcommand given"
  exit 1
end

commands = {
  'release' => GitFlowExtension::Command::Release.new
}

subcommands = Hash.new do |h,k|
  $stderr.puts "no such subcommand: #{k}"
  exit 1
end
subcommands['release'] = commands['release'].subcommands(subcommands)

opts   = GitFlowExtension::Command::Common.new.op.order(ARGV)
cmd    = opts.shift
subcmd = opts.shift

(class<<self;self;end).module_eval do
  define_method(:usage) do |msg|
    puts subcommands[cmd][subcmd].to_s
    puts "error: #{msg}" if msg
    exit 1
  end
end

begin
  subcommands[cmd][subcmd].parse(opts)
  commands[cmd].send(subcmd)
rescue => e
  if ENV['TRACE'] then
    puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
  end

  usage $!.to_s
end
