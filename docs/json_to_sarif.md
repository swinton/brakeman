# JSON to SARIF

## Contents

- [SARIF example report](#sarif-example-report)
- [(Work in Progress) Map](#work-in-progress-map)

## SARIF example report

The following example illustrates how Brakeman should generate a SARIF representation of its analysis.

```json
{
  "version": "2.1.0",
  "$schema": "http://json.schemastore.org/sarif-2.1.0-rtm.4",
  "runs": [
    {
      "tool": {
        "driver": {
          "name": "Brakeman",
          "informationUri": "https://brakemanscanner.org/",
          "rules": [
            {
              "id": 12,
              "shortDescription": {
                "text": "Checks for default routes"
              },
              "helpUri": "https://brakemanscanner.org/docs/warning_types/default_routes/",
              "properties": {
                "warning_type": "Default Routes",
                "check_name": "DefaultRoutes"
              }
            },
            {
              "id": 102,
              "shortDescription": {
                "text": "Checks for XSS in calls to content_tag"
              },
              "helpUri": "https://groups.google.com/d/msg/ruby-security-ann/8B2iV2tPRSE/JkjCJkSoCgAJ",
              "properties": {
                "warning_type": "Cross-Site Scripting",
                "check_name": "ContentTag"
              }
            }
          ]
        }
      },
      "artifacts": [
        {
          "location": {
            "uri": "config/routes.rb"
          }
        },
        {
          "location": {
            "uri": "Gemfile.lock"
          }
        }
      ],
      "results": [
        {
          "level": "warning",
          "message": {
            "text": "Any public method in `FooPutController` can be used as an action for `put` requests."
          },
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "config/routes.rb",
                  "index": 0
                },
                "region": {
                  "startLine": 1,
                  "startColumn": 0
                }
              }
            }
          ],
          "ruleId": 12,
          "ruleIndex": 0
        },
        {
          "level": "warning",
          "message": {
            "text": "Rails 3.2.9.rc2 `content_tag` does not escape double quotes in attribute values (CVE-2016-6316). Upgrade to Rails 3.2.22.4"
          },
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "Gemfile.lock",
                  "index": 1
                },
                "region": {
                  "startLine": 64,
                  "startColumn": 0
                }
              }
            }
          ],
          "ruleId": 102,
          "ruleIndex": 1
        }
      ]
    }
  ]
}
```

## (Work in Progress) Map

The following table maps properties between Brakeman's JSON report and their SARIF equivalents.

| JSONPath                            | SARIF Property                  | Example Value(s)                                                                       |
|:------------------------------------|:--------------------------------|:---------------------------------------------------------------------------------------|
| `$.scan_info.app_path`              | `TBD`                           | "/path/to/brakeman/test/apps/rails3.2"                                                 |
| `$.scan_info.rails_version`         | `TBD`                           | "3.2.9.rc2"                                                                            |
| `$.scan_info.security_warnings`     | `TBD`                           | 45                                                                                     |
| `$.scan_info.start_time`            | `TBD`                           | "2020-07-09 16:55:31 -0500"                                                            |
| `$.scan_info.end_time`              | `TBD`                           | "2020-07-09 16:55:31 -0500"                                                            |
| `$.scan_info.duration`              | `TBD`                           | 0.363584                                                                               |
| `$.scan_info.checks_performed[*]`   | `TBD`                           | ["BasicAuth", ...]                                                                     |
| `$.scan_info.number_of_controllers` | `TBD`                           | 4                                                                                      |
| `$.scan_info.number_of_models`      | `TBD`                           | 5                                                                                      |
| `$.scan_info.number_of_templates`   | `TBD`                           | 13                                                                                     |
| `$.scan_info.ruby_version`          | `TBD`                           | "2.7.1"                                                                                |
| `$.scan_info.brakeman_version`      | `TBD`                           | "4.8.2"                                                                                |
| `$.warnings[*].warning_type`        | `TBD`                           | "Default Routes"                                                                       |
| `$.warnings[*].warning_code`        | `$.runs[*].tool[*].rules[*].id` | 12                                                                                     |
| `$.warnings[*].fingerprint`         | `TBD`                           | "05a92f06689436b7b8189c358baab371de5f0fb7936ab206a11b251b0e5f7570"                     |
| `$.warnings[*].check_name`          | `TBD`                           | "DefaultRoutes"                                                                        |
| `$.warnings[*].message`             | `TBD`                           | "Any public method in `FooPutController` can be used as an action for `put` requests." |
| `$.warnings[*].file`                | `TBD`                           | "config/routes.rb"                                                                     |
| `$.warnings[*].line`                | `TBD`                           | null, 1                                                                                |
| `$.warnings[*].link`                | `TBD`                           | "https://brakemanscanner.org/docs/warning_types/default_routes/"                       |
| `$.warnings[*].code`                | `TBD`                           | "User.find(params[:id]).bio", "params[:bad_stuff]", null                               |
| `$.warnings[*].render_path`         | `TBD`                           | `TODO`                                                                                 |
| `$.warnings[*].location`            | `TBD`                           | `TODO`                                                                                 |
| `$.warnings[*].user_input`          | `TBD`                           | "params[:user_input]", null                                                            |
| `$.warnings[*].confidence`          | `TBD`                           | "Medium"                                                                               |
| `$.ignored_warnings[*]`             | `TBD`                           | `TODO`                                                                                 |
| `$.errors[*]`                       | `TBD`                           | `TODO`                                                                                 |
| `$.obsolete[*]`                     | `TBD`                           | `TODO`                                                                                 |

## Questions

- Does Brakeman have a sense of severity that we can map into the results? Should we default to "warning" for all results?
- What does `$.warnings[*].render_path` represent? Should we map this onto an appropriate SARIF property (there may be a better place, but this _could_ land in a _property bag_ under results, i.e. `$.runs[*].results[*].properties`)?
- We need the absolute physical location of a file containing a result. It looks like this is available from `$.warnings[*].file` and `$.warnings[*].line`, but as a relative location. How can we derive the absolute location from this?
- The `$.warnings[*].location` doesn't always seem to correspond directly with `$.warnings[*].file` / `$.warnings[*].location`, what is the reason for this redirection? Should we include both locations in the SARIF results?
