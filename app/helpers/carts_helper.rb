module CartsHelper
  def current_cart
    @current_cart ||= cart_for_user
  end

  private

  def cart_for_user
    return if !user_signed_in? || current_user.guest?
    if cookies.permanent[:cart_id].present?
      Cart.find(cookies.permanent[:cart_id])
    else
      save_to_cookie_and_return_cart
    end
  rescue ActiveRecord::RecordNotFound
    save_to_cookie_and_return_cart
  end

  def save_to_cookie_and_return_cart
    cart = Cart.create(user: current_user)
    cookies.permanent[:cart_id] = cart.id
    cart
  end
end
