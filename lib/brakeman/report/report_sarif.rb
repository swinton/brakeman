require 'brakeman/report/report_json'

class Brakeman::Report::SARIF < Brakeman::Report::JSON
  def generate_report
    sarif_log = {
      :version => '2.1.0',
      :$schema => 'https://schemastore.azurewebsites.net/schemas/json/sarif-2.1.0-rtm.4.json',
      :runs => runs,
    }
    JSON.pretty_generate sarif_log
  end

  def runs
    [
      {
        :tool => {
          :driver => {
            :name => 'Brakeman',
            :informationUri => 'https://brakemanscanner.org',
            :rules => rules,
          },
        },
        :results => results,
      },
    ]
  end

  def rules
    # TODO
    []
  end

  def results
    all_results = convert_to_hashes all_warnings
    all_results.map do |r|
      {
        :ruleId => '',
        :level => '',
        :message => {
          :text => r[:message],
        },
        :locations => [
          :physicalLocation => {
            :artifactLocation => {
              :uri => '',
              :index => '',
            },
            :region => {
              :startLine => '',
              :startColumn => '',
            }
          },
        ],
      }
    end
  end
end
