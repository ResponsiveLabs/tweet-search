Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "KEUY", "Other key"
end