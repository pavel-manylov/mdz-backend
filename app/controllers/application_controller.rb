class ApplicationController < ActionController::API
  rescue_from Exception, with: :exception
  rescue_from ActiveInteraction::Error, with: :interaction_error
  rescue_from ActiveInteraction::InvalidInteractionError, with: :invalid_interaction_error

  private

  def invalid_interaction_error(error)
    exception error, error.interaction.errors.to_a, 422
  end

  def interaction_error(error)
    exception error, [I18n.t('controller.errors.interaction_error')]
  end

  # @param  [Exception] error
  # @param  [Array<String>] error_messages
  # @param  [Integer] status_code
  def exception(error, error_messages = [I18n.t('controller.errors.exception')], status_code = 500)
    Rails.logger.error "Error #{error.message} (#{error.class}). Backtrace: \n#{error.backtrace.join("\n")}"
    render json: { errors: error_messages },
           status: status_code
  end
end
