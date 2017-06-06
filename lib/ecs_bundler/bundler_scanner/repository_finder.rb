module ECSBundler::BundlerScanner::RepositoryFinder
  GITHUB_REPO_REGEX = %r{(https?):\/\/(www.)?github\.com\/([\w.%-]*)\/([\w.%-]*)}

  # rails builds several gems that are not individual projects
  # some repos move and the old repo page still exists
  # some repos are not mostly ruby so the github search doesn't find them
  REPO_EXCEPTIONS =
    {
      actioncable:                 'rails/rails',
      actionmailer:                'rails/rails',
      actionpack:                  'rails/rails',
      actionview:                  'rails/rails',
      activejob:                   'rails/rails',
      activemodel:                 'rails/rails',
      activerecord:                'rails/rails',
      activesupport:               'rails/rails',
      bluepill:                    'bluepill-rb/bluepill',
      chunky_png:                  'wvanbergen/chunky_png',
      :"color-schemer" => 'at-import/color-schemer',
      delayed_job:                 'collectiveidea/delayed_job',
      execjs:                      'rails/execjs',
      faraday_middleware:          'lostisland/faraday_middleware',
      flamegraph:                  'SamSaffron/flamegraph',
      ffi:                         'ffi/ffi',
      :"foundation-rails" => 'zurb/foundation-rails',
      googleauth:                  'google/google-auth-library-ruby',
      gosu:                        'jlnr/gosu',
      :"guard-livereload"       => 'guard/guard-livereload',
      :"jquery-ujs"             => 'rails/jquery-ujs',
      json:                        'flori/json',
      kaminari:                    'kaminari/kaminari',
      :"kaminari-actionview"    => 'kaminari/kaminari',
      :"kaminari-activerecord"  => 'kaminari/kaminari',
      :"kaminari-core"          => 'kaminari/kaminari',
      :"modular-scale"          => 'modularscale/modularscale-sass',
      :"net-ssh-gateway"        => 'net-ssh/net-ssh-gateway',
      newrelic_rpm:                'newrelic/rpm',
      nokogiri:                    'sparklemotion/nokogiri',
      nokogumbo:                   'rubys/nokogumbo',
      oauth:                       'oauth-xx/oauth-ruby',
      oj:                          'ohler55/oj',
      passenger:                   'phusion/passenger',
      pg:                          'ged/ruby-pg',
      :"pry-doc" => 'pry/pry-doc',
      rails:                       'rails/rails',
      railties:                    'rails/rails',
      rake:                        'ruby/rake',
      resque:                      'resque/resque',
      :"resque-multi-job-forks" => 'stulentsev/resque-multi-job-forks',
      representable:               'trailblazer/representable',
      rr:                          'rr/rr',
      SassyLists:                  'at-import/SassyLists',
      :"Sassy-Maps"             => 'at-import/Sassy-Maps',
      :"sassy-math"             => 'at-import/Sassy-math',
      settingslogic:               'settingslogic/settingslogic',
      sinatra:                     'sinatra/sinatra',
      stripe:                      'stripe/stripe-ruby',
      thread_safe:                 'ruby-concurrency/thread_safe',
      tolk:                        'tolk/tolk',
      toolkit:                     'at-import/tookit',
      :"trailblazer-cells" => 'trailblazer/trailblazer-cells',
      turbolinks:                  'turbolinks/turbolinks',
      :"twitter-text" => 'twitter/twitter-text',
      zeus:                        'burke/zeus'
    }.freeze

  class << self
    def url(spec)
      return "https://github.com/#{REPO_EXCEPTIONS[spec.name.to_sym]}" unless REPO_EXCEPTIONS[spec.name.to_sym].nil?
      return spec.homepage if spec.homepage =~ GITHUB_REPO_REGEX
      match = spec.description.to_s.match(GITHUB_REPO_REGEX)
      match && match[0]
    end
  end
end
