module RestKit
  module Helpers

    def pod_install
      Dir.chdir(options[:ios_path]) {
        Bundler.with_clean_env {
          system 'pod install --no-repo-update'
        }
      }
    end

  end
end