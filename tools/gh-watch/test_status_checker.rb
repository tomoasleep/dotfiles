# frozen_string_literal: true

require_relative 'watch'

def anon_reviews(reviews)
  # anonymize review payloads to avoid including real user data in tests
  reviews.map do |r|
    r.transform_keys(&:to_s).reject { |k, _| k == 'author' }
  end
end

def anon_review_requests(rr)
  return [] unless rr

  if rr.is_a?(Array)
    rr.map { |e| e.transform_keys(&:to_s).reject { |k, _| k == 'requestedReviewer' } }
  elsif rr.is_a?(Hash) && rr['nodes'].is_a?(Array)
    { 'nodes' => rr['nodes'].map { |n| n.reject { |k, _| k == 'requestedReviewer' } } }
  else
    []
  end
end

# basic unit tests for StatusChecker.check_review_status
cases = []

cases << {
  name: 'only latestReviews COMMENTED',
  latest: [{ 'state' => 'COMMENTED' }],
  review_requests: nil,
  want: { approved: 0, changes_requested: 0, commented: 1, dismissed: 0, pending: 0 }
}

cases << {
  name: 'pending via reviewRequests array',
  latest: [],
  review_requests: [{ 'requestedReviewer' => { 'login' => 'alice' } }],
  want: { approved: 0, changes_requested: 0, commented: 0, dismissed: 0, pending: 1 }
}

cases << {
  name: 'mixed latestReviews and reviewRequests nodes',
  latest: [{ 'state' => 'APPROVED' }, { 'state' => 'COMMENTED' }],
  review_requests: { 'nodes' => [{ 'requestedReviewer' => { 'login' => 'bob' } }, { 'requestedReviewer' => { 'login' => 'carol' } }] },
  want: { approved: 1, changes_requested: 0, commented: 1, dismissed: 0, pending: 2 }
}

all_ok = true
cases.each do |c|
  latest = anon_reviews(c[:latest])
  rr = anon_review_requests(c[:review_requests])
  got = StatusChecker.check_review_status(latest, rr)
  if got == c[:want]
    puts "OK: #{c[:name]}"
  else
    all_ok = false
    puts "FAIL: #{c[:name]}"
    puts "  got:  #{got}"
    puts "  want: #{c[:want]}"
  end
end

exit(all_ok ? 0 : 1)
