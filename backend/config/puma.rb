# ===========================================
# Puma Web Server Configuration
# ===========================================

# Thread pool
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Workers (processes)
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

if ENV.fetch("RAILS_ENV", "development") == "production"
  workers ENV.fetch("WEB_CONCURRENCY") { 2 }
  preload_app!
end

# Port
port ENV.fetch("PORT") { 3000 }

# Environment
environment ENV.fetch("RAILS_ENV") { "development" }

# PID file
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Allow puma to be restarted by `bin/rails restart`
plugin :tmp_restart

# Callbacks
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
