#
# def _process_comments(number)
#   pulls = []
#   retrieve_comments(number).select {|comment|
#     (comment.body.match(/^- \[[ x]\] .+$/)) ? true : false
#   }.each do |comment|
#     pulls.push comment.body.match(/^- \[[ x]\] .+$/)[0]
#   end
#
#   pulls.uniq.sort {|a,b|
#     a.match(/pull\/(\d+)/)[1].to_i <=> b.match(/pull\/(\d+)/)[1].to_i
#   }.each do |line|
#     puts line
#   end
# end
#
# def _retrieve_comments(number)
#   per_page = 100
#   condition = {
#     :user => @client.github.user,
#     :repo => @client.github.repo,
#     :number => number,
#     :per_page => per_page,
#   }
#
#   comments = []
#   page = 1
#   while true do
#     condition[:page] = page
#
#     response = @client.github.issues.comments.list(condition)
#     response_comments = response.body.to_a
#     response_comments.map{|comment|
#       raise 'issue number not match' if comment.issue_url.match(/\/(\d+)$/)[1].to_i != number
#     }
#     comments += response_comments
#
#     break if response.body.to_a.size < per_page
#     page += 1
#   end
#
#   comments
# end
