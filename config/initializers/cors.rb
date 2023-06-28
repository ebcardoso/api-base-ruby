Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins Rails.application.secrets.cors_origin.present? ? Rails.application.secrets.cors_origin.split(" ").map(&:strip) : '*'
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
