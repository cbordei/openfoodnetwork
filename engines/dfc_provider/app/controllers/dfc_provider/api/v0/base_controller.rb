# frozen_string_literal: true

# Controller used to provide the API products for the DFC application
module DfcProvider
  module Api
    module V0
      class BaseController < ::Api::V0::BaseController
        skip_authorization_check

        before_action :check_authorization,
                      :check_user

        respond_to :json

        def show; end

        private

        def check_authorization
          return if access_token.present?

          head :unprocessable_entity
        end

        def check_user
          return if current_user.present?

          head :unauthorized
        end

        def check_enterprise
          return if current_enterprise.present?

          not_found
        end

        def current_enterprise
          @current_enterprise ||=
            case params[enterprise_id_param_name]
            when 'default'
              current_user.enterprises.first!
            else
              current_user.enterprises.find(params[enterprise_id_param_name])
            end
        end

        def enterprise_id_param_name
          :enterprise_id
        end

        def current_user
          @current_user ||= authorization_control.safe_process
        end

        def access_token
          request.headers['Authorization'].to_s.split(' ').last
        end

        def authorization_control
          DfcProvider::AuthorizationControl.new(access_token)
        end

        def not_found
          head :not_found
        end
      end
    end
  end
end