require 'test_helper'

class LinksControllerTest < ActionDispatch::IntegrationTest
  
  test "should update a link" do
    update_params = { link: { name: "a new name", url: "new.site.com" }}
    link = links(:link_1)
    assert link.name != update_params.dig(:link, :name)
    assert link.url != update_params.dig(:link, :url) 
    put link_url(link, params: update_params), as: :json
    assert_response 204
    link.reload
    assert link.name == update_params.dig(:link, :name)
    assert link.url == update_params.dig(:link, :url)
  end

  test "should destroy a link" do
    link = links(:link_1)
    link_count = Link.count
    delete link_url(link), as: :json
    assert_response 204
    assert Link.count == link_count - 1
  end
end
