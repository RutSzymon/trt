class ApplicationController < ActionController::API
  before_action :check_scope_header
  before_action :check_userid_header
  before_action :current_user

  private

  def current_user
    class_name = scope_header.classify
    id = userid_header.to_i
    class_name.constantize.find(id)
  rescue ActiveRecord::RecordNotFound => _e
    render json: { error: { message: 'User does not exist.' }, data: {} }, status: 500
  end

  def check_scope_header
    return if %w[operator agent].include?(scope_header)

    render json: { error: { message: 'Invalid AUTHENTICATED_SCOPE header' }, data: {} }, status: 500
  end

  def check_userid_header
    return if userid_header.present?

    render json: { error: { message: 'Invalid AUTHENTICATED_USERID header' }, data: {} }, status: 500
  end

  def scope_header
    request.headers['AUTHENTICATED_SCOPE'] || request.headers['HTTP_AUTHENTICATED_SCOPE']
  end

  def userid_header
    request.headers['AUTHENTICATED_USERID'] || request.headers['HTTP_AUTHENTICATED_USERID']
  end
end
