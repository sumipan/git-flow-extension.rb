
module GitFlowExtension
module Command
  class Common

    attr_reader :gfx

    def initialize
      @gfx = GitFlowExtension::Client.new
    end

    def op
      op  = OptionParser.new

      op.on('-u', '--user=USER', "github user", String) do |s|
        @gfx.github.user = s
      end

      op.on('-r', '--repo=REPOSITORY', "github repo", String) do |s|
        @gfx.github.repo = s
      end

      op.on('-t', '--token=TOKEN', "github token", String) do |s|
        @gfx.github.oauth_token = s
      end
    end
  end
end
end
