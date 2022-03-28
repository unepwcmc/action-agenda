require 'test_helper'

class LinksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  test "should update a link" do
    sign_in users(:user_1)
    update_params = { link: { url: "new.site.com" }}
    link = links(:link_1)
    assert link.url != update_params.dig(:link, :url) 
    put link_url(link, params: update_params), as: :json
    assert_response 204
    link.reload
    assert link.url == update_params.dig(:link, :url)
  end

  test "should destroy a link" do
    sign_in users(:user_1)
    link = links(:link_1)
    link_count = Link.count
    delete link_url(link), as: :json
    assert_response 204
    assert Link.count == link_count - 1
  end

  test "PUT update should redirect to sign in unless signed in" do
    link = links(:link_1)
    put link_url(link), as: :json
    assert_response :unauthorized
    assert JSON.parse(response.body).dig('error') == I18n.t('devise.failure.unauthenticated')
  end

  test "DELETE destroy should redirect to sign in unless signed in" do
    link = links(:link_1)
    delete link_url(link), as: :json
    assert_response :unauthorized
    assert JSON.parse(response.body).dig('error') == I18n.t('devise.failure.unauthenticated')
  end
end
