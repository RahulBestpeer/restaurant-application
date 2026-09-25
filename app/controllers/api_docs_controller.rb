class ApiDocsController < ActionController::Base
  def spec
    render(
      plain: Rails.root.join("swagger", "v1", "swagger.yaml").read,
      content_type: "application/yaml"
    )
  end
end
