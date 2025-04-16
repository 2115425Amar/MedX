threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

port ENV.fetch("PORT", 3000) # Ensure it binds to Render’s assigned port

environment ENV.fetch("RAILS_ENV") { "production" }

pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart

# Run the Solid Queue supervisor inside Puma for single-server deployments
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]
