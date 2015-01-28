## RestKit Generators for Rails
##### Generate iOS code to talk to your Rails API

**Warning: This is a work in progress and isn't ready for public consumption. It may still depend on other private libraries.**

### Getting Started

Add the gem to your Gemfile in Rails:
```
gem "restkit_generators", github: "Papercloud/restkit_generators", group: :development
```

Run bundle install from your Rails project root:
```
bundle install
```

Now run this from your Rails project root to install a local development Cocoapod to hold your generated code, as well as a configuration file for your Rails models:

```
rails g rest_kit:install --ios-path=/Users/me/myWork/myiOSProject
```

### Features

* Configuration File

A configuration file, `.ios_sdk_config.yml`, can be generated to allow excluding models / columns, as well as adding in additional columns for the iOS model that might not be persisted on the backend. This will also generate the podspec and folder where your SDK will be generated (as well as a Podfile if you don't have one yet).

* Generate Models

A _ModelName class is generated with all the properties that your Serializer of the same name exposes, plus a Core Data entity is added. A ModelName class is also created if it doesn't already exist. If you create your own file named ModelName within your project directory, and re-run the generator, the auto-generated one will be removed.
```
rails g rest_kit:model ModelName --ios-path=../path/to/ios/project/dir --data-model-path=../optional/path/to/xcdatamodel
```

* Generate Mappings

Generates a category on ModelName returning an appropriate RKManagedObjectMapping.
```
rails g rest_kit:mapping ModelName --ios-path=../path/to/ios/project/dir
```

* Generate Routes

This take a route name, including namespace, as it would be used in a named route helper in Rails.
```
rails g rest_kit:route api_countries --ios-path=../path/to/ios/project/dir
```

### Configuration



### Notes & Caveats

* All mappings and response descriptors assume use of active_model_serializers with `embed :ids, include: true`, which is a global config in AMS 0.9 anyway.
* All generates have an --include-timestamps boolean option which defaults to false.
