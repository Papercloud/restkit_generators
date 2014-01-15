require "spec_helper"

describe "a whole app" do
  
  it "generates classes which compile" do
    ios_path = File.join(RestkitGenerators::Engine.root, "spec/dummy-ios/Dummy")

    system "rm -rf #{ios_path}/Generated"

    params = ["--ios-path=#{ios_path}"]
    Rails::Generators.invoke("rest_kit:model", ["Comment"] + params)
    Rails::Generators.invoke("rest_kit:model", ["Post"] + params)
    Rails::Generators.invoke("rest_kit:model", ["Tag"] + params)
    Rails::Generators.invoke("rest_kit:model", ["User"] + params)

    Rails::Generators.invoke("rest_kit:mapping", ["Post"] + params)
    Rails::Generators.invoke("rest_kit:mapping", ["Comment"] + params)
    Rails::Generators.invoke("rest_kit:mapping", ["Tag"] + params)
    Rails::Generators.invoke("rest_kit:mapping", ["User"] + params)

    Rails::Generators.invoke("rest_kit:route", ["api_post"] + params)
    Rails::Generators.invoke("rest_kit:route", ["api_posts"] + params)
    Rails::Generators.invoke("rest_kit:route", ["api_post_tags"] + params)
    Rails::Generators.invoke("rest_kit:route", ["api_post_comments"] + params)
    Rails::Generators.invoke("rest_kit:route", ["api_post_user"] + params)

    Dir.chdir(ios_path) {
      Bundler.with_clean_env {
        system 'pod install --no-repo-update'
        system "xctool -workspace Dummy.xcworkspace -scheme Dummy -sdk iphonesimulator"
      }
    }
  end

end