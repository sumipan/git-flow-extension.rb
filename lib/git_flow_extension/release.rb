# encoding: utf-8

require 'git'

module GitFlowExtension
	class Release

		attr_accessor :client

		def self.instance(client)
			unless @instance then
				@instance = self.new
				@instance.client = client
			end

			raise 'instance is null' unless @instance

			@instance
		end

		def create
		end

		def start(number)
		end

		def update(number)
			origin_issue = @client.github.issues.get(:user => @client.github.user, :repo => @client.github.repo, :number => number)
			raise 'issue not found' unless origin_issue

			issue = Issue.new(origin_issue.body, @client)
			begin
				body = issue.render
				raise 'body is empty' if body.empty?
			rescue => e
				@client.log.fatal(e.to_s)
				@client.log.fatal(e.backtrace)
				exit 1
			end

			if origin_issue.respond_to?('head') then
				@client.github.pull_requests.update(:user => @client.github.user, :repo => @client.github.repo, :number => number, :body => body) if body
			else
				@client.github.issues.edit(:user => @client.github.user, :repo => @client.github.repo, :number => number, :body => body) if body
			end
		end

		def finish(number)
		end
	end
end
