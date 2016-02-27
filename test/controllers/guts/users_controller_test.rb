require "test_helper"

module Guts
  class UsersControllerTest < ActionController::TestCase
    setup do
      @user   = guts_users :admin_user
      @group  = guts_groups :test_group
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:users)
    end
    
    test "should get index with group" do
      get :index, group: @group.id
      assert_response :success
      assert_not_nil assigns(:users)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create user without group" do
      assert_difference("User.count") do
        post :create, user: {
          name: "Some User",
          email: "some_user@domain.com",
          password: "xyz123",
          password_confirmation: "xyz123"
        }
      end

      assert_redirected_to users_path
      assert_equal "User was successfully created.", flash[:notice]
    end
    
    test "should fail to create user and send back to new" do
      post :create, user: {name: "", email: ""}
      assert_template "guts/users/new"
    end
    
    test "should create user with group" do
      assert_difference("User.count") do
        post :create, user: {
          name: "Some User",
          email: "some_user@domain.com",
          password: "xyz123",
          password_confirmation: "xyz123",
          group_ids: [@group.id]
        }
      end

      assert_redirected_to users_path
      assert_equal "User was successfully created.", flash[:notice]
    end
    
    test "should show user" do
      get :show, id: @user
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @user
      assert_response :success
    end

    test "should update user" do
      patch :update, id: @user, user: { name: @user.name }
      assert_redirected_to users_path
      assert_equal "User was successfully updated.", flash[:notice]
    end
    
    test "should fail to update user and send back to edit" do
      patch :update, id: @user, user: { name: "", email: "" }
      assert_template "guts/users/edit"
    end

    test "should destroy user" do
      assert_difference("User.count", -1) do
        delete :destroy, id: @user
      end

      assert_redirected_to users_path
      assert_equal "User was successfully destroyed.", flash[:notice]
    end
    
    test "should switch user by ID" do
      post :switch_user, user_id: @user.id
      assert_match /you are now logged in/i, flash[:notice]
      assert_response :success
      assert_not_nil assigns(:users)
    end
  end
end