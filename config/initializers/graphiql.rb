if Rails.env.development?
  GraphiQL::Rails.config.headers['AUTHENTICATED_SCOPE'] = ->(_context) { 'operator' }
  GraphiQL::Rails.config.headers['AUTHENTICATED_USERID'] = ->(_context) { Operator.first&.id }
end
