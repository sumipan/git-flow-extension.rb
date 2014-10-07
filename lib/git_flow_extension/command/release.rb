require 'optparse'

module GitFlowExtension
module Command
	class Release < Common
		attr_reader :version_code, :base, :head, :number

		def initialize
			super

			@version_code = nil
			@base = nil
			@head = nil
			@number = nil
		end

		def subcommands(subcommands)
			commands = subcommands.clone

			create = op
			create.banner += ' create subcommand'
			create.on('--version-code=VERSION_CODE', 'release version code', Integer) do |s|
			end

			create.on('--base=BRANCH', 'BASE branch', String) do |s|
			end

			create.on('--head=BRANCH', 'HEAD branch', String) do |s|
			end

			update = op
			update.banner += ' update subcommand'
			update.on('--number=NUMBER', 'github issue number', Integer) do |i|
				@number = i
			end

			commands['create'] = create
			commands['update'] = update
			commands
		end

		def create
			raise '--base required' unless @base
			raise '--head required' unless @head
			raise '--version-code required' unless @version_code
		end

		def start
		end

		def update
			raise '--number required' unless @number

			@gfx.release.update(@number)
		end

		def finish
		end
	end
end
end
