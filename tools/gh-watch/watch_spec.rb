# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/mock'
require 'ostruct'
require_relative 'watch'

class TestStatusChecker < Minitest::Test
  def setup
    @checker = StatusChecker
  end

  def test_ci_status_all_success
    status_check_rollup = [
      { 'conclusion' => 'SUCCESS', 'name' => 'test1' },
      { 'conclusion' => 'SUCCESS', 'name' => 'test2' },
      { 'conclusion' => 'SUCCESS', 'name' => 'test3' }
    ]
    result = @checker.check_ci_status(status_check_rollup)
    assert_equal({ success: 3, failure: 0, pending: 0, total: 3 }, result)
  end

  def test_ci_status_mixed
    status_check_rollup = [
      { 'conclusion' => 'SUCCESS', 'name' => 'test1' },
      { 'conclusion' => 'FAILURE', 'name' => 'test2' },
      { 'conclusion' => 'SUCCESS', 'name' => 'test3' },
      { 'conclusion' => 'FAILURE', 'name' => 'test4' },
      { 'conclusion' => nil, 'status' => 'IN_PROGRESS', 'name' => 'test5' }
    ]
    result = @checker.check_ci_status(status_check_rollup)
    assert_equal({ success: 2, failure: 2, pending: 1, total: 5 }, result)
  end

  def test_ci_status_empty
    status_check_rollup = []
    result = @checker.check_ci_status(status_check_rollup)
    assert_equal({ success: 0, failure: 0, pending: 0, total: 0 }, result)
  end

  def test_review_status_only_approved
    latest_reviews = [
      { 'author' => { 'login' => 'user1' }, 'state' => 'APPROVED' },
      { 'author' => { 'login' => 'user2' }, 'state' => 'APPROVED' }
    ]
    result = @checker.check_review_status(latest_reviews)
    assert_equal({ approved: 2, changes_requested: 0, commented: 0, dismissed: 0, pending: 0 }, result)
  end

  def test_review_status_mixed
    latest_reviews = [
      { 'author' => { 'login' => 'user1' }, 'state' => 'APPROVED' },
      { 'author' => { 'login' => 'user2' }, 'state' => 'CHANGES_REQUESTED' },
      { 'author' => { 'login' => 'user3' }, 'state' => 'COMMENTED' },
      { 'author' => { 'login' => 'user4' }, 'state' => 'PENDING' },
      { 'author' => { 'login' => 'user5' }, 'state' => 'DISMISSED' }
    ]
    result = @checker.check_review_status(latest_reviews)
    assert_equal({ approved: 1, changes_requested: 1, commented: 1, dismissed: 1, pending: 1 }, result)
  end

  def test_review_status_empty
    latest_reviews = []
    result = @checker.check_review_status(latest_reviews)
    assert_equal({ approved: 0, changes_requested: 0, commented: 0, dismissed: 0, pending: 0 }, result)
  end

  def test_review_status_pending_from_review_requests_array
    latest_reviews = []
    review_requests = [ { 'requestedReviewer' => { 'login' => 'anon1' } } ]
    result = @checker.check_review_status(latest_reviews, review_requests)
    assert_equal({ approved: 0, changes_requested: 0, commented: 0, dismissed: 0, pending: 1 }, result)
  end

  def test_review_status_pending_from_review_requests_nodes
    latest_reviews = [ { 'state' => 'APPROVED' }, { 'state' => 'COMMENTED' } ]
    review_requests = { 'nodes' => [ { 'requestedReviewer' => { 'login' => 'anon2' } }, { 'requestedReviewer' => { 'login' => 'anon3' } } ] }
    result = @checker.check_review_status(latest_reviews, review_requests)
    assert_equal({ approved: 1, changes_requested: 0, commented: 1, dismissed: 0, pending: 2 }, result)
  end
end

class TestTerminalRenderer < Minitest::Test
  def setup
    @renderer = TerminalRenderer
  end

  def test_render_all_success
    pr_data = {
      'number' => 2,
      'state' => 'OPEN',
      'mergeable' => 'MERGEABLE',
      'statusCheckRollup' => [
        { 'conclusion' => 'SUCCESS', 'name' => 'test1' },
        { 'conclusion' => 'SUCCESS', 'name' => 'test2' },
        { 'conclusion' => 'SUCCESS', 'name' => 'test3' }
      ],
      'latestReviews' => [
        { 'author' => { 'login' => 'user1' }, 'state' => 'APPROVED' },
        { 'author' => { 'login' => 'user2' }, 'state' => 'APPROVED' }
      ],
      'title' => 'Bump eslint from 3.19.0 to 6.6.0'
    }
    result = @renderer.render(pr_data)
    assert_match(%r{#2 \[OPEN MERGEABLE Checks: ✓3/3 Review: 👍2\]}, result)
    assert_match(/Bump eslint from 3.19.0 to 6.6.0/, result)
  end

  def test_render_mixed_ci_status
    pr_data = {
      'number' => 4,
      'state' => 'OPEN',
      'mergeable' => 'CONFLICTING',
      'statusCheckRollup' => [
        { 'conclusion' => 'SUCCESS', 'name' => 'test1' },
        { 'conclusion' => 'FAILURE', 'name' => 'test2' },
        { 'conclusion' => nil, 'status' => 'IN_PROGRESS', 'name' => 'test3' }
      ],
      'latestReviews' => [
        { 'author' => { 'login' => 'user1' }, 'state' => 'CHANGES_REQUESTED' },
        { 'author' => { 'login' => 'user2' }, 'state' => 'COMMENTED' }
      ],
      'title' => 'Fix bug'
    }
    result = @renderer.render(pr_data)
    assert_match(%r{#4 \[OPEN CONFLICTING Checks: ✓1/3 ✗1/3 ⏳1/3 Review: ❌1 💬1\]}, result)
    assert_match(/Fix bug/, result)
  end

  def test_render_no_checks
    pr_data = {
      'number' => 3,
      'state' => 'MERGED',
      'mergeable' => 'MERGEABLE',
      'statusCheckRollup' => [],
      'latestReviews' => [],
      'title' => 'Add feature'
    }
    result = @renderer.render(pr_data)
    assert_match(/#3 \[MERGED MERGEABLE Checks: – Review: –\]/, result)
    assert_match(/Add feature/, result)
  end

  def test_render_no_reviews
    pr_data = {
      'number' => 5,
      'state' => 'OPEN',
      'mergeable' => 'MERGEABLE',
      'statusCheckRollup' => [
        { 'conclusion' => 'SUCCESS', 'name' => 'test1' }
      ],
      'latestReviews' => [],
      'title' => 'WIP'
    }
    result = @renderer.render(pr_data)
    assert_match(%r{#5 \[OPEN MERGEABLE Checks: ✓1/1 Review: –\]}, result)
    assert_match(/WIP/, result)
  end
end

class MockCommandRunner
  def initialize(stdout, stderr, status)
    @stdout = stdout
    @stderr = stderr
    @status = status
  end

  def capture3(_command)
    [@stdout, @stderr, @status]
  end
end

class TestPRWatcher < Minitest::Test
  def test_fetch_pr_success
    json_response = '[{"number":2,"state":"OPEN","mergeable":"MERGEABLE","statusCheckRollup":[{"conclusion":"SUCCESS","name":"test1"}],"latestReviews":[{"author":{"login":"user1"},"state":"APPROVED"}],"title":"Test PR"}]'
    mock_runner = MockCommandRunner.new(json_response, '', OpenStruct.new(success?: true))
    watcher = PRWatcher.new('test-branch', mock_runner)

    result = watcher.fetch_pr

    assert_equal 2, result['number']
    assert_equal 'OPEN', result['state']
    assert_equal 'MERGEABLE', result['mergeable']
  end

  def test_fetch_pr_not_found
    mock_runner = MockCommandRunner.new('[]', '', OpenStruct.new(success?: true))
    watcher = PRWatcher.new('test-branch', mock_runner)

    result = watcher.fetch_pr

    assert_nil result
  end

  def test_fetch_pr_command_failure
    mock_runner = MockCommandRunner.new('', 'Not in a git repository', OpenStruct.new(success?: false))
    watcher = PRWatcher.new('test-branch', mock_runner)

    assert_raises(CommandExecutionError) do
      watcher.fetch_pr
    end
  end

  def test_fetch_pr_invalid_json
    mock_runner = MockCommandRunner.new('invalid json', '', OpenStruct.new(success?: true))
    watcher = PRWatcher.new('test-branch', mock_runner)

    assert_raises(CommandExecutionError) do
      watcher.fetch_pr
    end
  end

  def test_format_pr
    pr_data = {
      'number' => 2,
      'state' => 'OPEN',
      'mergeable' => 'MERGEABLE',
      'statusCheckRollup' => [
        { 'conclusion' => 'SUCCESS', 'name' => 'test1' }
      ],
      'latestReviews' => [
        { 'author' => { 'login' => 'user1' }, 'state' => 'APPROVED' }
      ],
      'title' => 'Test PR'
    }
    watcher = PRWatcher.new('test-branch')

    result = watcher.format_pr(pr_data)
    assert_match(%r{#2 \[OPEN MERGEABLE Checks: ✓1/1 Review: 👍1\] Test PR}, result)
  end

  def test_sanitize_branch_name
    PRWatcher.new('test-branch')
    # プライベートメソッドなので直接呼べないが、コマンド実行時に問題ないことを確認

    # 危険な文字を含むブランチ名
    mock_runner = MockCommandRunner.new('[]', '', OpenStruct.new(success?: true))
    watcher = PRWatcher.new('branch; rm -rf /', mock_runner)
    result = watcher.fetch_pr
    assert_nil result
  end
end

class TestWatchModeRunner < Minitest::Test
  def test_run_single_update
    mock_watcher = Minitest::Mock.new
    mock_watcher.expect :fetch_pr, {
      'number' => 1,
      'state' => 'OPEN',
      'mergeable' => 'MERGEABLE',
      'statusCheckRollup' => [],
      'latestReviews' => [],
      'title' => 'Test'
    }
    mock_watcher.expect :format_pr, '#1 [OPEN MERGEABLE Checks: – Review: –] Test', [Hash]

    output = StringIO.new
    runner = WatchModeRunner.new(mock_watcher, 0.1, output)

    Thread.new { runner.run }
    sleep 0.2

    output_string = output.string
    assert_match(/#1 \[OPEN MERGEABLE Checks: – Review: –\] Test/, output_string)
    assert_match(/\[\d{2}:\d{2}:\d{2}\]/, output_string)

    mock_watcher.verify
  end

  def test_run_handles_error
    mock_watcher = Minitest::Mock.new
    mock_watcher.expect :fetch_pr, nil do
      raise CommandExecutionError, 'Test error'
    end

    output = StringIO.new
    runner = WatchModeRunner.new(mock_watcher, 0.1, output)

    Thread.new { runner.run }
    sleep 0.2

    assert_match(/Error: Test error/, output.string)

    mock_watcher.verify
  end
end
