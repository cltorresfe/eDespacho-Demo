require 'test_helper'

class ClienteAcomasControllerTest < ActionController::TestCase
  setup do
    @cliente_acoma = cliente_acomas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cliente_acomas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cliente_acoma" do
    assert_difference('ClienteAcoma.count') do
      post :create, cliente_acoma: { apellidos_cliente: @cliente_acoma.apellidos_cliente, dv_cliente: @cliente_acoma.dv_cliente, nombres_cliente: @cliente_acoma.nombres_cliente, run_cliente: @cliente_acoma.run_cliente }
    end

    assert_redirected_to cliente_acoma_path(assigns(:cliente_acoma))
  end

  test "should show cliente_acoma" do
    get :show, id: @cliente_acoma
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cliente_acoma
    assert_response :success
  end

  test "should update cliente_acoma" do
    patch :update, id: @cliente_acoma, cliente_acoma: { apellidos_cliente: @cliente_acoma.apellidos_cliente, dv_cliente: @cliente_acoma.dv_cliente, nombres_cliente: @cliente_acoma.nombres_cliente, run_cliente: @cliente_acoma.run_cliente }
    assert_redirected_to cliente_acoma_path(assigns(:cliente_acoma))
  end

  test "should destroy cliente_acoma" do
    assert_difference('ClienteAcoma.count', -1) do
      delete :destroy, id: @cliente_acoma
    end

    assert_redirected_to cliente_acomas_path
  end
end
