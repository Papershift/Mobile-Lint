# Lint the GitHub PR title & body
fail('PR is classed as Work in Progress') if github.pr_title.include? 'WIP'

fail('Please limit PR title to 50 characters') if github.pr_title.length > 50
fail('Please use more than one word in PR title.') if github.pr_title.split.count < 2
fail('Please remove period from end of PR title.') if github.pr_title.split('').last == '.'

first_char_in_pr_title = github.pr_title.split('').first
fail('Please start PR title with capital letter.') if first_char_in_pr_title != first_char_in_pr_title.upcase
fail('Please provide a link to the related Asana task in the PR body.') unless github.pr_body.include? 'https://app.asana.com/'

# Check branch name
unless github.branch_for_head.match(/(feature|fix)\/[a-z]{2}_[a-z\d-]{3,25}/)
  fail('Please follow the branch name structure `<feature or fix>/<initials>_<dasherized-topic>`.')
end

# Check commit messages for merge commits
git.commits.each do |commit|
  fail_message = "Please prevent merging other branches, rebase onto them instead.\n#{commit.sha}"
  fail(fail_message) if commit.message.match(/merge.*branch.*into/i)
end

# Warn when there is a big PR
warn('Big PR') if git.lines_of_code > 500
