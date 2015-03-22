require 'uri'
require 'net/https'
require 'json'

class Basis
  def self.authorize(email, password)
    u = URI.parse('https://app.mybasis.com/login')
    http = Net::HTTP.new(u.host, u.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request = Net::HTTP::Post.new(u.request_uri)
    request.set_form_data({'next' => 'https://app.mybasis.com',
      'submit' => 'Login',
      'username' => email,
      'password' => password})
    response = http.request(request)
    if cookie = response['set-cookie']
      tok_match = cookie.match(/access_token=([0-9a-f]+);/)
      return Basis.new(tok_match[1])
    else
      return nil
    end
  end

  def get_metrics(date)
    url = "https://app.mybasis.com/api/v1/metricsday/me?day=#{date}&padding=0&heartrate=true&steps=true&calories=true&gsr=true&skin_temp=true&air_temp=true"
    data = https_fetch(url, @token)
    return JSON.parse(data)
  end

  def get_activities
    url = "https://app.mybasis.com/api/v2/users/me/days/#{date}/activities?type=run,walk,bike&expand=activities"
    data = https_fetch(url, @token)
    return JSON.parse(data)
  end

  def get_sleep
    url = "https://app.mybasis.com/api/v2/users/me/days/#{date}/activities?type=sleep&expand=activities.stages,activities.events"
    data = https_fetch(url, @token)
    return JSON.parse(data)
  end

  private

  def initialize(token)
    @token = token
  end

  def https_fetch(url, token)
    u = URI.parse(url)
    http = Net::HTTP.new(u.host, u.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request = Net::HTTP::Get.new(u.request_uri)
    request.add_field('Cookie', "access_token=#{token}; scope=login")
    http.request(request).body
  end
end
