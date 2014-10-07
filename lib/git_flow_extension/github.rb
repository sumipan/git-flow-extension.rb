require "git_flow_extension/version"
require "github_api"
require "git"

module GitFlowExtension

	class Github < Github::Client

		attr_accessor :user, :repo, :client

		def self.instance(client)
			unless @instance then
				@instance = self.new
				@instance.client = client
			end

			raise 'instance is null' unless @instance

			@instance
		end

		def initialize
			git = Git.open(Dir::pwd)
			match = git.remotes.first.url.match(/[:\/](.+)\/(.+)\.git/)
			if match[1] && match[2] then
				super user: match[1], repo: match[2] do |config|
					yield config if block_given?
				end

				user = match[1]
				repo = match[2]
			else
				raise 'github user, repo detect fail'
			end
		end
	end

end
