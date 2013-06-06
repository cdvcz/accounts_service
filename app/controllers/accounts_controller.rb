##
# Kontroler pro spravu uzivatelskych uctu

class AccountsController < BaseController
  ##
  # Overi login, heslo a aplikaci uzivatele
  def authenticate
    @application = Application.find_by_name(params[:application_code])

    if @application
      @application_account = @application.account_applications
        .joins(:account).includes(:account)
        .where(accounts: { login: params[:login] }).first

      @account = @application_account.try(:account)
    end

    if @account  and @account.authenticate(params[:password])
      render json: @application_account
    else
      render json: { authorized: false }, status: 401
    end
  end
end
