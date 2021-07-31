class ApplicationController < ActionController::Base
    around_action :set_locale

    def set_locale(&action)
        locale = params[:locale] || I18n.default_locale
        I18n.with_locale(locale, &action)
    end

end
