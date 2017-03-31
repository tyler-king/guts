require 'test_helper'

module Guts
  class ApplicationPolicyTest < PolicyTest
    test 'granted concern' do
      user    = guts_users :admin_user
      result  = user.send :grant_resource_string, %i(guts navigation_item)
      result2 = user.send :grant_resource_string, %i(guts type)
      result3 = user.send :grant_resource_string, Guts::User
      result4 = user.send :grant_resource_string, user
      result5 = user.send :grant_resource_string, Hash
      result6 = user.send :grant_resource_string, 'Boo'

      assert_equal 'Guts::NavigationItem', result
      assert_equal 'Guts::Type', result2
      assert_equal 'Guts::User', result3
      assert_equal 'Guts::User', result4
      assert_equal 'Hash', result5
      assert_equal 'String', result6
    end
  end
end