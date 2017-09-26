module Helpers
  def preserving_environment
    old_api_token = Edools.api_token
    yield
    Edools.api_token = old_api_token
  end
end
