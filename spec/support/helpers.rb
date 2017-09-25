module Helpers
  def preserving_environment
    old_api_token = Edools.api_token
    old_subdomain = Edools.subdomain

    yield

    Edools.api_token = old_api_token
    Edools.subdomain = old_subdomain
  end
end
