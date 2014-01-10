require "spec_helper"

describe "a whole app" do
  
  it "generates classes which compile" do
    ios_path = File.join(RestkitGenerators::Engine.root, "spec/dummy-ios/Dummy")

    system "rm -rf #{ios_path}/Generated"

    params = ["--ios-path=#{ios_path}"]
    Rails::Generators.invoke("restkit_generators:model", ["Comment"] + params)
    Rails::Generators.invoke("restkit_generators:model", ["Post"] + params)
    Rails::Generators.invoke("restkit_generators:model", ["Tag"] + params)
    Rails::Generators.invoke("restkit_generators:model", ["User"] + params)

    Dir.chdir(ios_path) {
      Bundler.with_clean_env {
        system 'pod install --no-repo-update'
        system "xctool -workspace Dummy.xcworkspace -scheme Dummy -sdk iphonesimulator"
      }
    }
  end

end