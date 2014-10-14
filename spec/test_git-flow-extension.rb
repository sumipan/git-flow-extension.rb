require "minitest/autorun"

require 'git_flow_extension'

describe GitFlowExtension do
end

describe GitFlowExtension::Github do
	before do
		@gfx = GitFlowExtension::Client.new
	end

	it "should github repository" do
		@gfx.github.user.must_equal 'sumipan'
		@gfx.github.repo.must_equal 'git-flow-extension.rb'
	end

	it "should github issue tweak" do
		@gfx.github.issues.list(:user => @gfx.github.user, :repo => @gfx.github.repo).size.must_equal 0
	end
end

describe GitFlowExtension::Release do
	before do
		@gfx = GitFlowExtension::Client.new
	end

	it "must create new release issue" do
		@gfx.release.must_be_instance_of GitFlowExtension::Release
	end
end
