module RestKit
  module Helpers

    def pod_init
      puts "No Podfile found, generating one for you!"

      Dir.chdir(options[:ios_path]) {
        Bundler.with_clean_env {
          system 'pod init'
        }
      }
    end

    def pod_install
      Dir.chdir(options[:ios_path]) {
        Bundler.with_clean_env {
          system 'pod install --no-repo-update'
        }
      }
    end

  end
end