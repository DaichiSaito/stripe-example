class CreditsController < ApplicationController
  def create
    Stripe.api_key = Rails.application.credentials.stripe[:secret_key]
    stripe_customer = Stripe::Customer.create(
      :source => params[:stripe_token]
    )
    
    @stripe_information = StripeInformation.new
    @stripe_information.user = current_user
    @stripe_information.stripe_customer_id = stripe_customer.id
    @stripe_information.credit_no_last4 = stripe_customer.sources.data[0].last4
    if @stripe_information.save
      redirect_to credits_path, notice: 'クレジット情報を登録しました。'
    else
      flash.now[:alert] = "クレジット情報の登録に失敗しました。"
      render 'show'
    end
  end

  def update
    Stripe.api_key = Rails.application.credentials.stripe[:secret_key]
    stripe_customer = Stripe::Customer.retrieve(current_user.stripe_information.stripe_customer_id)
    stripe_customer.source = params[:stripe_token]
    @stripe_customer = stripe_customer.save
    if current_user.stripe_information.update(credit_no_last4: @stripe_customer.sources.data[0].last4)
      flash[:success] = "クレジット情報を更新しました。"
      redirect_to credits_path, notice: 'クレジット情報を更新しました。'
    else
      flash.now[:alert] = "クレジット情報の更新に失敗しました。"
      render 'show'
    end
  end

  def show
  end
end
