SocialNet - a Ruby client for social networks API
===========================================

SocialNet helps you write apps that need to interact with Instagram, Byte, Twitter, and Facebook.

## Note: Only Instagram and Byte works at the moment

After [configuring your Byte app](#configuring-your-byte-app), you can run commands like:

```ruby
user = SocialNet::Byte::User.find_by username: 'ollie'
user.username #=> "ollie"
user.follower_count #=> 300
```

After [configuring your Twitter app](#configuring-your-twitter-app), you can run commands like:

```ruby
user = SocialNet::Twitter::User.find_by screen_name: 'collab'
user.screen_name #=> "Collab"
user.follower_count #=> 48_200
```

For Instagram, you can run commands like:

```ruby
user = SocialNet::Instagram::User.new username: 'Collab'
user.videos #=>
  # @caption=
  #  "30 Likes, 3 Comments - Collab (@collab) on Instagram: “@dribble2much’s ‘Ankle Bully’ ft. @lianev and @globalhooper is out now. Hit our Stories for the…”",
  # @id="BjGBDnMA7tk",
  # @link="https://www.instagram.com/p/BjGBDnMA7tk/",
  # @thumbnail_url=
  #  "https://scontent-lax3-2.cdninstagram.com/vp/b022f60aa0dca66bf69b42ef120bebaa/5B196165/t51.2885-15/e15/32276184_235590730544586_2982097953704902656_n.jpg",
  # @video_url=
  #  "https://scontent-lax3-2.cdninstagram.com/vp/dca9fd7707b3e00d5efd18c98c54e6ba/5B19755C/t50.2886-16/32028990_233788607376727_7097250491033190400_n.mp4">
```

After [configuring your Facebook app](#configuring-your-facebook-app), you can run commands like:

```ruby
page = SocialNet::Facebook::Page.find_by username: 'collab'
page.username #=> "collab"
page.likes #=> 23289
```

How to install
==============

To install on your system, run

    gem install social_net

To use inside a bundled Ruby project, add this line to the Gemfile:

    gem 'social_net', '~> 0.1.1'

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
* The User methods are now deprecated due to changes in Instagram's new policies

Use [SocialNet::Instagram::User]() to:

* retrieve an Instagram user by username
* retrieve an Instagram user by id
* access the number of followers of an Instagram user
* retrieve recent videos of an Instagram user

```ruby
user = SocialNet::Instagram::User.find_by username: 'collab'
user.follower_count #=> 24198

user = SocialNet::Instagram::User.find_by id: 270587948
user.follower_count #=> 24198

user.videos #=>
  # [SocialNet::Instagram::Models::Video
  #   @caption='Diet starts Monday... 😂🍩',
  #   @file='https://scontent.cdninstagram.com/t50.2886-16/17192719_791273527696774_5253726776697290752_n.mp4',
  #   @id='1464710084172115373_487786346',
  #   @likes=127,
  #   @thumbnail='https://scontent.cdninstagram.com/t51.2885-15/e15/17076697_308353549580106_8220285822193106944_n.jpg']"
```

Use [SocialNet::Instagram::Video]() to:

* retrieve an Instagram video by shortcode
* retrieve a private Instagram video by shortcode

```ruby
video = SocialNet::Instagram::Video.find_by shortcode: 'BW-nC7xg8ZX'
video = SocialNet::Instagram::Video.find_by shortcode: 'BX8sBI0hS9cyuR0iORRax8F3OamLIJZCwaZRyQ0' # Private shortcode


video.link #=> 'https://www.instagram.com/p/BW-nC7xg8ZX/'
video.file #=> 'https://scontent.cdninstagram.com/t50.2886-16/20372137_156190564936990_2601958215176421376_n.mp4'
```

SocialNet::Byte::User
--------------------

Use [SocialNet::Byte::User]() to:

* retrieve a Byte user by username
* retrieve a Byte user by id
* retrieve posts of a Byte user

```ruby
user = SocialNet::Byte::User.find_by username: 'ollie'
user.follower_count #=> 0

user = SocialNet::Byte::User.find_by id: 'PUEMKGYDBFAZ3HSRSAFGBAI5HA'
user.follower_count #=> 0

user.posts #=>
 # {:posts=>
 # [#<SocialNet::Byte::Models::Post:0x00007fb71b8705a8
 #  @author_id="PUEMKGYDBFAZ3HSRSAFGBAI5HA",
 #  @caption="i’m in ya house (ft. @Tishsimmonds)",
 #  @category="comedy",
 #  @comment_count=110,
 #  @date=1580391236,
 #  @id="WZPPQ5LQJZAAHP4BWFLM6PRBNM",
 #  @like_count=2439,
 #  @loop_count=34891,
 #  @thumb_src="https://e6k9t9a9.stackpathcdn.com/videos/5VVTQ4TTZBCRRHWDUPIZNUWDKM.jpg",
 #  @video_src="https://e6k9t9a9.stackpathcdn.com/videos/5VVTQ4TTZBCRRHWDUPIZNUWDKM-h264.mp4">],
 # :next_page=>"CXWZB7CTMYLTA"}

user.posts(next_page: 'CXWZB7CTMYLTA') #=>
  # {:posts=>
  # [#<SocialNet::Byte::Models::Post:0x00007fb718468788
  #  @author_id="PUEMKGYDBFAZ3HSRSAFGBAI5HA",
  #  @caption="pov of a hungry person thinking byte is a delivery food app",
  #  @category="comedy",
  #  @comment_count=95,
  #  @date=1580043689,
  #  @id="PNHNHKO3RZF2HJVHSD64V4X3LE",
  #  @like_count=2605,
  #  @loop_count=23982,
  #  @share_url="https://byte.co/b/B69eUGbPcDM",
  #  @thumb_src="https://e6k9t9a9.stackpathcdn.com/videos/XRIRCMQZGBAUDLCWUJQPHGYYEE.jpg",
  #  @video_src="https://e6k9t9a9.stackpathcdn.com/videos/XRIRCMQZGBAUDLCWUJQPHGYYEE-h264.mp4">,
  # :next_page=>"CXWPROPUQCCNQ"}
```

Use [SocialNet::Byte::Post]() to:

* retrieve a Byte post by id

```ruby
post = SocialNet::Byte::Post.find_by id: 'WZPPQ5LQJZAAHP4BWFLM6PRBNM'

post.caption #=> "i’m in ya house (ft. @Tishsimmonds)"
post.video_src #=> "https://e6k9t9a9.stackpathcdn.com/videos/5VVTQ4TTZBCRRHWDUPIZNUWDKM-h264.mp4"
```

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

Configuring your Byte app
============================

Once the app is created, copy your access token and add it to your
code with the following snippet of code (replacing with your own access token)
:

```ruby
SocialNet::Byte.configure do |config|
  config.access_token = 'abcdefg'
end
```

Configuring with environment variables
--------------------------------------

As an alternative to the approach above, you can configure your app with
a variable. Setting the following environment variable:

```bash
export BYTE_ACCESS_TOKEN='abcdefg'
```

is equivalent to configuring your app with the initializer:

```ruby
SocialNet::Byte.configure do |config|
  config.access_token = 'abcdefg'
end
```

so use the approach that you prefer.
If a variable is set in both places, then `SocialNet::Byte.configure` takes precedence.

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
