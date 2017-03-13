SocialNet - a Ruby client for social networks API
===========================================

SocialNet helps you write apps that need to interact with Twitter, Instagram and Facebook.


After [configuring your Twitter app](#configuring-your-twitter-app), you can run commands like:

```ruby
user = SocialNet::Twitter::User.find_by screen_name: 'collab'
user.screen_name #=> "Collab"
user.follower_count #=> 48_200
```
After [configuring your Instagram app](#configuring-your-instagram-app), you can run commands like:

```ruby
user = SocialNet::Instagram::User.find_by username: 'Collab'
user.username #=> "Collab"
user.follower_count #=> 7025
```

After [configuring your Facebook app](#configuring-your-facebook-app), you can run commands like:

```ruby
page = SocialNet::Facebook::Page.find_by username: 'collab'
page.username #=> "collab"
page.likes #=> 30094
```

How to install
==============

To install on your system, run

    gem install net

To use inside a bundled Ruby project, add this line to the Gemfile:

    gem 'social_net', '~> 0.1.0'

Since the gem follows [Semantic Versioning](http://semver.org),
indicating the full version in your Gemfile (~> *major*.*minor*.*patch*)
guarantees that your project won’t occur in any error when you `bundle update`
and a new version of SocialNet is released.

Available resources
===================

SocialNet::Twitter::User
------------------

Use [SocialNet::Twitter::User]() to:

* retrieve a Twitter user by screen name
* retrieve a list of Twitter users by screen names
* access the number of followers of a Twitter user

```ruby
user = SocialNet::Twitter::User.find_by screen_name: 'collab'
user.follower_count #=> 48_200

users = SocialNet::Twitter::User.where screen_name: ['collab', 'brohemian6']
users.map(&:follower_count).sort #=> [12, 48_200]
```

*The methods above require a configured Twitter app (see below).*

SocialNet::Instagram::User
--------------------

Use [SocialNet::Instagram::User]() to:

* retrieve an Instagram user by username
* retrieve an Instagram user by id
* access the number of followers of an Instagram user

```ruby
user = SocialNet::Instagram::User.find_by username: 'collab'
user.follower_count #=> 24198

user = SocialNet::Instagram::User.find_by id: 270587948
user.follower_count #=> 24198
```

*The methods above require a configured Instagram app (see below).*

SocialNet::Facebook::Page
--------------------

Use [SocialNet::Facebook::Page]() to:

* retrieve a Facebook page by username
* access the number of likes of a Facebook user

```ruby
page = SocialNet::Facebook::Page.find_by username: 'collab'
page.likes #=> 7025
```

SocialNet::Facebook::User
--------------------

Use [SocialNet::Facebook::User]() to:

* retrieve a Facebook user by username

```ruby
user = SocialNet::Facebook::User.find_by username: '10100829454613149'
user.first_name #=> Jeremy
```

* Include a Facebook access_token parameter in order to access pages information for a certain user

```ruby
user = SocialNet::Facebook::User.find_by username: '10100829454613149', access_token: 'abc123'
user.pages #=> [{"name"=>"Jeremy Video Game", "id"=>"1627249647512991"}, {"name"=>"Influencer Plus", "id"=>"629655227132365"}]
```

*The methods above require a configured Facebook app (see below).*

Configuring your Twitter app
============================

In order to use SocialNet you must create an app in the [Twitter Application Manager](https://apps.twitter.com/app/new).

Once the app is created, copy the API key and secret and add them to your
code with the following snippet of code (replacing with your own key and secret)
:

```ruby
SocialNet::Twitter.configure do |config|
  config.apps.push key: 'abcd', secret: 'efgh'
end
```

Configuring with environment variables
--------------------------------------

As an alternative to the approach above, you can configure your app with
variables. Setting the following environment variables:

```bash
export TWITTER_API_KEY='abcd'
export TWITTER_API_SECRET='efgh'
```

is equivalent to configuring your app with the initializer:

```ruby
SocialNet::Twitter.configure do |config|
  config.apps.push key: 'abcd', secret: 'efgh'
end
```

so use the approach that you prefer.
If a variable is set in both places, then `SocialNet::Twitter.configure` takes precedence.

Configuring your Instagram app
============================

In order to use SocialNet you must create an app in the
[Instagram Client Manager](http://instagram.com/developer/clients/register).

Once the app is created, copy the Client ID and add it to your
code with the following snippet of code (replacing with your own client id)
:

```ruby
SocialNet::Instagram.configure do |config|
  config.client_id = 'abcdefg'
end
```

Configuring with environment variables
--------------------------------------

As an alternative to the approach above, you can configure your app with
a variable. Setting the following environment variable:

```bash
export INSTAGRAM_CLIENT_ID='abcdefg'
```

is equivalent to configuring your app with the initializer:

```ruby
SocialNet::Instagram.configure do |config|
  config.client_id = 'abcdefg'
end
```

so use the approach that you prefer.
If a variable is set in both places, then `SocialNet::Instagram.configure` takes precedence.

Configuring your Facebook app
============================

In order to use SocialNet you must create an app in the [Facebook Application Manager](https://developers.facebook.com/apps/).

Once the app is created, copy the API key and secret and add them to your
code with the following snippet of code (replacing with your own key and secret)
:

```ruby
SocialNet::Facebook.configure do |config|
  config.client_id = 'abcdefg'
  config.client_secret = 'abcdefg'
end
```

Configuring with environment variables
--------------------------------------

As an alternative to the approach above, you can configure your app with
variables. Setting the following environment variables:

```bash
export FACEBOOK_CLIENT_ID='abcd'
export FACEBOOK_CLIENT_SECRET='efgh'
```

is equivalent to configuring your app with the initializer:

```ruby
SocialNet::Facebook.configure do |config|
  config.client_id = 'abcd'
  config.client_secret = 'efgh'
end
```

so use the approach that you prefer.
If a variable is set in both places, then `SocialNet::Facebook.configure` takes precedence.

How to test
===========

To run tests, type:

```bash
rspec
```

SocialNet uses [VCR](https://github.com/vcr/vcr) so by default tests do not run
HTTP requests.

If you need to run tests against the live Twitter API or Instagram API,
configure your [Twitter app](#configuring-your-twitter-app) or your [Instagram app](#configuring-your-instagram-app)  using environment variables,
erase the cassettes, then run `rspec`.


How to release new versions
===========================

If you are a manager of this project, remember to upgrade the [SocialNet gem](http://rubygems.org/gems/net)
whenever a new feature is added or a bug gets fixed.

Make sure all the tests are passing, document the changes in CHANGELOG.md and
README.md, bump the version, then run

    rake release

Remember that the net gem follows [Semantic Versioning](http://semver.org).
Any new release that is fully backward-compatible should bump the *patch* version (0.1.x).
Any new version that breaks compatibility should bump the *minor* version (0.x.0)
