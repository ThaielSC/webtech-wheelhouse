Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "https://thaielsc.github.io", "http://localhost:5500"
    resource %r{\A/api/v1/services(?:/[^/]+)?\z}, headers: [], methods: [ :get ]
  end
end
