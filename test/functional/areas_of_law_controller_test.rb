require 'test_helper'

class AreasOfLawControllerTest < ActionController::TestCase
  setup do
    @area_of_law = areas_of_law(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:areas_of_law)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create area_of_law" do
    assert_difference('AreaOfLaw.count') do
      post :create, area_of_law: { name: @area_of_law.name, old_id: @area_of_law.old_id }
    end

    assert_redirected_to area_of_law_path(assigns(:area_of_law))
  end

  test "should show area_of_law" do
    get :show, id: @area_of_law
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @area_of_law
    assert_response :success
  end

  test "should update area_of_law" do
    put :update, id: @area_of_law, area_of_law: { name: @area_of_law.name, old_id: @area_of_law.old_id }
    assert_redirected_to area_of_law_path(assigns(:area_of_law))
  end

  test "should destroy area_of_law" do
    assert_difference('AreaOfLaw.count', -1) do
      delete :destroy, id: @area_of_law
    end

    assert_redirected_to areas_of_law_path
  end
end
