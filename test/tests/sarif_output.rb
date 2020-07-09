require_relative '../test'
require 'json'

class SARIFOutputTests < Minitest::Test
  def setup
    @@sarif ||= JSON.parse(Brakeman.run("#{TEST_PATH}/apps/rails3.2").report.to_sarif)
  end

  def test_log_shape
    assert_equal '2.1.0', @@sarif['version']
    assert_equal 'https://schemastore.azurewebsites.net/schemas/json/sarif-2.1.0-rtm.4.json', @@sarif['$schema']
  end

  def test_runs_shape
    assert_equal 1, @@sarif['runs'].length
    assert_equal ['tool', 'results'], @@sarif['runs'][0].keys
    assert_equal ['driver'], @@sarif['runs'][0]['tool'].keys
  end

  def test_results_shape
    assert_equal 45, @@sarif['runs'][0]['results'].length
  end
end
