require 'test_helper'

class CustomerQuotesControllerTest < ActionController::TestCase
  setup do
    @customer_quote = customer_quotes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:customer_quotes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create customer_quote" do
    assert_difference('CustomerQuote.count') do
      post :create, customer_quote: { address: @customer_quote.address, email: @customer_quote.email, full_name: @customer_quote.full_name, rut: @customer_quote.rut, total_quote: @customer_quote.total_quote, user_id: @customer_quote.user_id }
    end

    assert_redirected_to customer_quote_path(assigns(:customer_quote))
  end

  test "should show customer_quote" do
    get :show, id: @customer_quote
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @customer_quote
    assert_response :success
  end

  test "should update customer_quote" do
    patch :update, id: @customer_quote, customer_quote: { address: @customer_quote.address, email: @customer_quote.email, full_name: @customer_quote.full_name, rut: @customer_quote.rut, total_quote: @customer_quote.total_quote, user_id: @customer_quote.user_id }
    assert_redirected_to customer_quote_path(assigns(:customer_quote))
  end

  test "should destroy customer_quote" do
    assert_difference('CustomerQuote.count', -1) do
      delete :destroy, id: @customer_quote
    end

    assert_redirected_to customer_quotes_path
  end
end
