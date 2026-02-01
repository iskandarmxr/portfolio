# ===========================================
# Rack Attack - Rate Limiting Configuration
# ===========================================

class Rack::Attack
  # Cache store
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # Throttle login attempts by IP
  throttle("login/ip", limit: 5, period: 60.seconds) do |req|
    req.ip if req.path == "/login" && req.post?
  end

  # Throttle login attempts by email
  throttle("login/email", limit: 5, period: 60.seconds) do |req|
    if req.path == "/login" && req.post?
      req.params["email"].to_s.downcase.gsub(/\s+/, "")
    end
  end

  # Throttle contact form submissions
  throttle("contact/ip", limit: 3, period: 60.seconds) do |req|
    req.ip if req.path == "/fragments/contact" && req.post?
  end

  # General request throttle
  throttle("req/ip", limit: 300, period: 5.minutes) do |req|
    req.ip unless req.path.start_with?("/assets")
  end

  # Block bad actors (optional - uncomment to enable)
  # blocklist("block bad actors") do |req|
  #   Rack::Attack::Fail2Ban.filter("bad-actors-#{req.ip}", maxretry: 10, findtime: 1.minute, bantime: 1.hour) do
  #     req.path.include?("wp-admin") || req.path.include?("phpmyadmin")
  #   end
  # end

  # Custom response for throttled requests
  self.throttled_responder = lambda do |request|
    match_data = request.env["rack.attack.match_data"]
    now = match_data[:epoch_time]
    retry_after = match_data[:period] - (now % match_data[:period])

    [
      429,
      {
        "Content-Type" => "text/html",
        "Retry-After" => retry_after.to_s
      },
      ["<p>Too many requests. Please retry in #{retry_after} seconds.</p>"]
    ]
  end
end
