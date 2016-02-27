require "test_helper"

module Guts
  class MediaControllerTest < ActionController::TestCase
    include ActionDispatch::Routing::UrlFor
    
    setup do
      @medium     = guts_media :test_file
      @content    = guts_contents :test_page
      @user       = guts_users :admin_user
      @routes     = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:media)
    end
    
    test "should get index for friendly" do
      get :index, content_id: @content.id, filable_type: "Guts::Content"
      assert_response :success
      assert_not_nil assigns(:media)
    end
    
    test "should get index for non friendly" do
      get :index, user_id: @user.id, filable_type: "Guts::User"
      assert_response :success
      assert_not_nil assigns(:media)
    end
    
    test "should get new" do
      get :new, content_id: @content.id, filable_type: "Guts::Content"
      assert_response :success
    end
    
    test "should create medium" do
      assert_difference("Medium.count") do
        post :create,
          content_id: @content.id,
          filable_type: "Guts::Content",
          medium: {
            title: "Demo File",
            file: fixture_file_upload("/guts/files/spongebob.png", "image/png")
          }
      end

      assert_redirected_to polymorphic_path([@content, :media])
      assert_match /successfully created/, flash[:notice]
    end
    
    test "should not create medium and send back to new" do
      post :create,
        content_id: @content.id,
        filable_type: "Guts::Content",
        medium: {
          title: ""
        }

      assert_template "guts/media/new"
    end
    
    test "should show medium" do
      get :show, id: @medium, content_id: @content.id, filable_type: "Guts::Content"
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @medium, content_id: @content.id, filable_type: "Guts::Content"
      assert_response :success
    end
    
    test "should update medium" do
      patch :update, id: @medium.id, content_id: @content.id, filable_type: "Guts::Content", medium: { title: "Demo Me" }
      assert_redirected_to polymorphic_path([@content, :media])
      assert_match /successfully updated/, flash[:notice]
    end

    test "should fail to edit medium and send back to edit" do
      patch :update, id: @medium.id, content_id: @content.id, filable_type: "Guts::Content", medium: { title: "" }
      assert_template "guts/media/edit"
    end

    test "should destroy media" do
      assert_difference("Medium.count", -1) do
        delete :destroy, id: @medium, content_id: @content.id, filable_type: "Guts::Content"
      end

      assert_redirected_to polymorphic_path([@content, :media])
      assert_match /successfully destroyed/, flash[:notice]
    end
    
    test "should get editor insert" do
      get :editor_insert, id: @medium, content_id: @content.id, filable_type: "Guts::Content"
      assert_response :success
      assert_template "guts/media/editor_insert"
      assert_template layout: false
    end
    
    test "should allow for custom paginated limit" do
      get :index, per_page: 100
      assert_equal 100, assigns(:per_page).to_i
    end
  end
end