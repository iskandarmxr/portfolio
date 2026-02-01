# ===========================================
# CORS Configuration for Frontend Requests
# ===========================================

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV.fetch("FRONTEND_URL", "http://localhost"),
            /localhost:\d+/,
            /127\.0\.0\.1:\d+/

    resource "/fragments/*",
      headers: :any,
      methods: [:get, :post, :options],
      expose: ["HX-Trigger", "HX-Redirect", "HX-Refresh"],
      max_age: 600

    resource "/cable",
      headers: :any,
      methods: [:get, :post, :options]
  end
end
