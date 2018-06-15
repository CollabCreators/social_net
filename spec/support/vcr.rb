require 'webmock/rspec'
require 'vcr'

VCR.configure do |c|
  c.configure_rspec_metadata!
  c.cassette_library_dir = 'spec/support/cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('INSTAGRAM_ACCESS_TOKEN') { SocialNet::Instagram.configuration.access_token }
  c.filter_sensitive_data('ACCESS_TOKEN') do |interaction|
    if interaction.request.headers['Authorization']
      interaction.request.headers['Authorization'].first
    elsif interaction.response.body.include?('is_private') || interaction.response.body.include?('Page Not Found')
      nil
    end
  end
  c.filter_sensitive_data(12345678) do |interaction|
    if interaction.response.status.code == 429
      interaction.response.headers['X-Rate-Limit-Reset'].first
    end
  end
  c.ignore_hosts 'graph.facebook.com'
end
