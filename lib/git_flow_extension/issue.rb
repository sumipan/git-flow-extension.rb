# encoding: utf-8

require 'json'

module GitFlowExtension
  class Issue

    attr_reader :issue, :client

    def initialize(issue, client)
      @issue  = issue
      p @issue.pull_request
      raise "not pull_request " + @issue.number unless @issue.pull_request
      
      @client = client
      @cache  = Hash.new

      @client.github.pull_requests.list(:user => @client.github.user, :repo => @client.github.repo, :state => 'open').each do |pull|
        @cache[pull.number] = pull
      end

      @client.github.pull_requests.list(:user => @client.github.user, :repo => @client.github.repo, :state => 'closed').each do |pull|
        @cache[pull.number] = pull
      end
    end

    def base
      @client.log.info('base: ' + @issue.pull_request.base.ref)
      @issue.pull_request.base.ref
    end

    def head
      @client.log.info('head: ' + @issue.pull_request.head.ref)
      @issue.pull_request.head.ref
    end

    def tag
      @client.log.info('tag: not supported')
      ''
    end

    def body
      index = @issue.body.index(/^----$/) || 0
      @issue.body.slice(0, index)
    end

    def cached_pull(number)
      unless @cache.keys.include?(number) then
        @cache[number] = @client.github.pull_requests.get(:user => @client.github.user, :repo => @client.github.repo, :number => number).body
      end

      @cache[number]
    end

    def opened_pulls
      pulls = []

      @client.github.pull_requests.list(:user => @client.github.user, :repo => @client.github.repo, :base => head).each do |pull|
        @client.log.info('include #' + pull.number.to_s + ': ' + pull.title)
        @cache[pull.number] = pull
        pulls.push pull
      end

      pulls
    end

    def merged_pulls
      pulls = []

      request  = sprintf("https://%s:x-oauth-basic@api.github.com/repos/%s/%s/compare/%s...%s", @client.github.oauth_token, @client.github.user, @client.github.repo, base, head)
      response = `curl #{request}`
      require 'nkf'
      response = NKF.nkf("-w", response)
      JSON.parse(response)['commits'].each do |commit|
        if match = commit['commit']['message'].match(/^Merge pull request #(\d+)/) then
          pull = cached_pull(match[1])
          if pull.merged_at then
            pull.state = 'merged'
          end

          @client.log.info('include #' + pull.number.to_s + ': ' + pull.title)
          pulls.push pull
        end
      end

      pulls
    end

    def noted_pulls
      pulls = []

      issue.body.scan(/^- \[.\] (?:<del>)?\[.+\]\(.+\)(?:<\/del>)?/).each do |line|

        checked  = ( line.match(/^ *?- \[x\] /) ) ? true : false
        number   = line.match(/pull\/(\d+)/)[1]
        pull = cached_pull(number.to_i)
        pull.checked = checked

        if pull.merged_at then
          pull.state = 'merged'
        end

        pulls.push pull
      end

      pulls
    end

    def render
      pulls = noted_pulls

      # なんで指定したのか忘れたので一旦コメントアウトする
      # if base != 'master' && !head.match(/^(hotfix|release)/) then
        pulls.concat(
          merged_pulls.select{|p1|
            !pulls.map{|p2| p2.number}.include?(p1.number)
          }
        )
      # end

      pulls.concat(
        opened_pulls.select{|p1|
          !pulls.map{|p2| p2.number}.include?(p1.number)
        }
      )

      pulls.sort! {|a,b| a.number <=> b.number }

      merged = []
      opened = []
      closed = []
      pulls.each do |pull|
        case pull.state
        when 'open'
          opened.push pull
        when 'closed'
          closed.push pull
        when 'merged'
          merged.push pull
        else
          raise 'invalid state'
        end
      end

      io = StringIO.new
      $stdout = io

      puts body
      puts ''
      puts '----'
      puts ''

      puts 'マージ済みの修正'
      puts '----'
      puts ''
      merged.each { |pull|
        next if pull.base.ref != head # head と違う p-r は除外する
        puts sprintf("- [%s] [%s](%s)", (pull.checked ? 'x' : ' '), pull.title, pull.html_url)
      }
      puts ''

      puts 'マージされていない修正'
      puts '----'
      puts ''
      opened.each { |pull|
        puts sprintf("- [%s] [%s](%s)", (pull.checked ? 'x' : ' '), pull.title, pull.html_url)
      }
      puts ''

      puts 'クローズされた修正'
      puts '----'
      puts ''
      closed.each { |pull|
        puts sprintf("- [%s] <del>[%s](%s)</del>", (pull.checked ? 'x' : ' '), pull.title, pull.html_url)
      }
      puts ''

      stdout  = $stdout.string
      $stdout = STDOUT

      stdout
    end
  end
end
