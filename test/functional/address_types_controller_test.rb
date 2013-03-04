require 'test_helper'

class AddressTypesControllerTest < ActionController::TestCase
  setup do
    @address_type = address_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:address_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create address_type" do
    assert_difference('AddressType.count') do
      post :create, address_type: { name: @address_type.name }
    end

    assert_redirected_to address_type_path(assigns(:address_type))
  end

  test "should show address_type" do
    get :show, id: @address_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @address_type
    assert_response :success
  end

  test "should update address_type" do
    put :update, id: @address_type, address_type: { name: @address_type.name }
    assert_redirected_to address_type_path(assigns(:address_type))
  end

  test "should destroy address_type" do
    assert_difference('AddressType.count', -1) do
      delete :destroy, id: @address_type
    end

    assert_redirected_to address_types_path
  end
end
