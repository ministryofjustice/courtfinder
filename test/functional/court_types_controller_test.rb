require 'test_helper'

class CourtTypesControllerTest < ActionController::TestCase
  setup do
    @court_type = court_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:court_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create court_type" do
    assert_difference('CourtType.count') do
      post :create, court_type: { name: @court_type.name, old_id: @court_type.old_id }
    end

    assert_redirected_to court_type_path(assigns(:court_type))
  end

  test "should show court_type" do
    get :show, id: @court_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @court_type
    assert_response :success
  end

  test "should update court_type" do
    put :update, id: @court_type, court_type: { name: @court_type.name, old_id: @court_type.old_id }
    assert_redirected_to court_type_path(assigns(:court_type))
  end

  test "should destroy court_type" do
    assert_difference('CourtType.count', -1) do
      delete :destroy, id: @court_type
    end

    assert_redirected_to court_types_path
  end
end
