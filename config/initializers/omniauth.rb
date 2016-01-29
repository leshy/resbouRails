OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 231418697191360, '078669bee303cc02851871b7809d89d7'
end
