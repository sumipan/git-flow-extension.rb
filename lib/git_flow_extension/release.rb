# encoding: utf-8


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

		# new issue
		def create
		end

		def start(number)
		end

		def update(number)
			issue = @client.github.issues.get(:user => @client.github.user, :repo => @client.github.repo, :number => number)
			raise 'issue not found' unless issue

			parse_release_body(issue.body)

			process_comments(number)
		end

		def finish(number)
		end

		def parse_release_body(issue)
			begin
				checked = issue.body.match(/QAチェック済み\r?\n----+(.*?)\r?\n\r?\n/)[1]
				not_checked = issue.body.match(/QA未チェック\r?\n----+(.*?)\r?\n\r?\n/)[1]

				parse_pull_request_line(checked)
				parse_pull_request_line(not_checked)
			rescue
				raise 'issue body parse error. ' + $!.to_s
			end
		end

		def parse_pull_request_line(lines)
			p lines.split(/\r?\n/)
		end

		def process_comments(number)
			pulls = []
			retrieve_comments(number).select {|comment|
				(comment.body.match(/^- \[[ x]\] .+$/)) ? true : false
			}.each do |comment|
				pulls.push comment.body.match(/^- \[[ x]\] .+$/)[0]
			end

			pulls.uniq.sort {|a,b|
				a.match(/pull\/(\d+)/)[1].to_i <=> b.match(/pull\/(\d+)/)[1].to_i
			}.each do |line|
				puts line
			end
		end

		def retrieve_comments(number)
      per_page = 100
      condition = {
        :user => @client.github.user,
        :repo => @client.github.repo,
        :number => number,
        :per_page => per_page,
      }

      comments = []
      page = 1
      while true do
        condition[:page] = page

        response = @client.github.issues.comments.list(condition)
				response_comments = response.body.to_a
				response_comments.map{|comment|
					raise 'issue number not match' if comment.issue_url.match(/\/(\d+)$/)[1].to_i != number
				}
        comments += response_comments

        break if response.body.to_a.size < per_page
        page += 1
      end

      comments
    end
	end
end
