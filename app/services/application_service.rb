# frozen_string_literal: true

# ApplicationService to store common modules that will be used in the services directory
class ApplicationService
  include Dry::Monads[:result, :do]
end
