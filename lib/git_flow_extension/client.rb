
module GitFlowExtension
	class Client
		def github
			GitFlowExtension::Github.instance(self)
		end

		def release
			GitFlowExtension::Release.instance(self)
		end
	end
end
