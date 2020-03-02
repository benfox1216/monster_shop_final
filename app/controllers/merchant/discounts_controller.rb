class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = current_user.merchant.discounts
  end

  def new
  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.create(discount_params)
    if discount.save
      redirect_to "/merchant/discounts"
    else
      generate_flash(discount)
      render :new
    end
  end

  def edit
    
  end

  def update

  end

  def destroy

  end

  private

  def discount_params
    params.permit(:amount, :num_items)
  end
end