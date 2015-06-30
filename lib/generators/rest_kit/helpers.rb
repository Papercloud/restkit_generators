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

    def association_exists?(model, association)
      singular_symbol = association.active_record.name.demodulize.underscore.to_sym
      plural_symbol = association.active_record.name.demodulize.pluralize.underscore.to_sym

      model.reflect_on_association(singular_symbol) || model.reflect_on_association(plural_symbol) ? true : false
    end

  end
end
