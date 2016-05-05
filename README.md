[![Build Status](https://magnum.travis-ci.com/lightspeedretail/chef-chef-stats_ag.svg?token=hGPXx24AgMgUkkRGwnLG&branch=master)](https://magnum.travis-ci.com/lightspeedretail/chef-chef-stats_ag)

# chef-stats\_ag

This cookbook installs and configures the Stats-AG application. (https://github.com/lightspeedretail/stats-ag).

## Platform

This cookbook has been tested on the following platforms:

* Ubuntu (14.04)

Please note we plan on testing it with other platforms in the near future although it may or may not work on other platforms without any modification. Please
[report issues](https://github.com/lightspeedretail/chef-stats_ag/issues) so necessary fixes can be applied.


## Usage

#### stats_ag::default


## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['stats_ag']['git_tag']</tt></td>
    <td>String</td>
    <td>The version of stats-ag to install</td>
    <td><tt>0.1.0</tt></td>
  </tr>
  <tr>
    <td><tt>['stats_ag']['scripts_dir']</tt></td>
    <td>String</td>
    <td>Path where custom scripts will be located</td>
    <td><tt>/opt/stats-ag/scripts</tt></td>
  </tr>
  <tr>
    <td><tt>['stats_ag']['base_dir']</tt></td>
    <td>String</td>
    <td>Base dir of the stats-ag application</td>
    <td><tt>/opt/stats-ag</tt></td>
  </tr>
  <tr>
    <td><tt>['stats_ag']['metrics_dir']</tt></td>
    <td>String</td>
    <td>Location where metrics files will be stored</td>
    <td><tt>/var/log/stats-ag/metrics/</tt></td>
  </tr>
  <tr>
    <td><tt>['stats_ag']['date_prefix_format']</tt></td>
    <td>String</td>
    <td>The date pefix format to be used by stats-ag (SYSLOG, ISO8601, RFC3339)</td>
    <td><tt>SYSLOG</tt></td>
  </tr>
  <tr>
    <td><tt>['stats_ag']['log_file']</tt></td>
    <td>String</td>
    <td>Location of the stats-ag log file</td>
    <td><tt>/var/log/stats-ag/status.log</tt></td>
  </tr>
  <tr>
    <td><tt>['stats_ag']['custom_scripts']</tt></td>
    <td>Array</td>
    <td>An array of hashes that include the file names to be used for custom scripts.<br/>
      Example:<br/>
      ```ruby
      ['stats_ag']['custom_scripts'] = [
        {'name' => 'active_processes', 'action' => 'create'}
      ]
      ```
    </td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['stats_ag']['custom_scripts_cookbook']</tt></td>
    <td>String</td>
    <td>Cookbook that contains files for custom checks</td>
    <td><tt>stats_ag</tt></td>
  </tr>
  <tr>
    <td><tt>['stats_ag']['metrics_rotate_frequency']</tt></td>
    <td>Integer</td>
    <td>The number of days worth of files for a given metric to keep</td>
    <td><tt>5</tt></td>
  </tr>
  <tr>
    <td><tt>['stats_ag']['install_from_source']</tt></td>
    <td>Boolean</td>
    <td>Whether or not to install from source or not</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['stats_ag']['bin_location']</tt></td>
    <td>String</td>
    <td>URL of the stats-ag binary to install</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['stats_ag']['bin_checksum']</tt></td>
    <td>String</td>
    <td>SHA256 checksum of the stats-ag binary to install</td>
    <td><tt>nil</tt></td>
  </tr>
</table>

