Sidekiq.configure_client do |config|
  config.redis = { namespace: Rails.configuration.active_job.queue_name_prefix }
end

Sidekiq.configure_server do |config|
  config.redis = { namespace: Rails.configuration.active_job.queue_name_prefix }
end