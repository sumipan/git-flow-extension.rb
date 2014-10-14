
module GitFlowExtension
	class Client
		attr_reader :log

		def initialize
			@log = Logger.new(STDOUT)
			@log.level = Logger::INFO
			@log.level = Logger::DEBUG if ENV['TRACE']
		end

		def github
			GitFlowExtension::Github.instance(self)
		end

		def release
			GitFlowExtension::Release.instance(self)
		end
	end
end
