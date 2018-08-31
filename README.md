# TheCaptain Rails
The gist is that this is housing Rail's specific logic for handling Captain responses and submissions in a Rails project.

Main core feature is the ability to subscribe / explicitly listen for Webhooks that a developer would like to Handel in a specific manner.

I.E. If a Webhook comes back for an IP or Content analysis. A developer may want to allow specific class handlers to manage / analyze these pieces of information differently and directed to other parts of the application. 

(AKA: Single Responsibility Rule)

## Usage


## Installation
Add this line to your application's Gemfile:

```ruby
gem "the_captain", git: "https://github.com/VianetManagement/the-captain-ruby.git", branch: "3.0.0"
gem 'the_captain_rails', git: "https://github.com/VianetManagement/the-captain-rails"
```


## Configuration

### Webhook events

#### Configuring The Rails Router Path

Ensure we mount the controller path to handel requests.

`/config/routes.rb`
```ruby
Rails.application.routes.draw do
  mount TheCaptain::Events::Engine => "/captain/events"
  # ....
end
```

Your webhook endpoint will look something like `http://[HOST]/captain/events`

#### Configuring Webhook Listeners

`/config/initializer/the_captain.rb`

```ruby
TheCaptain::Event.configure do |config|
  config.subscribe("Account Abuse") { |event| ... }
  
  # Alternatively you can also define a class that contains a `call/1` method
   config.subscribe("Account Abuse", AccountManagment::Abuse.new)
   
   # If you wish for all events to pass through a single entry point or you want to log something about any webhook 
   # passthrough
   config.all { |event| ... }
   
    # [again] Alternatively you can also define a class that contains a `call/1` method
   config.all WebhookManager.new
end
```

Be default the `.subscribe/2` method will listen and attempt to parse which **Kit Name** triggered the given webhook.

You can modify the listening key by configuring the `.event_key_filter/1`

```ruby

TheCaptain::Event.configure do |config|
  config.event_key_filter = proc { |event| event.[some_key_value_in_response] }
  config.subscribe([modified_filer_key_result]) { |event| }
end

```

You can also reject or accept events by modifying the `.event_filter/1`

**Note:** If the filter does not return an event. The `all` listener will not be triggered.

```ruby
TheCaptain::Event.configure do |config|
  # If the event's decision id is 1000, then ignore it (i.e.: don't return the event)
  config.event_filter = proc { |event| event unless event.descition.id == 1000 }
end
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
