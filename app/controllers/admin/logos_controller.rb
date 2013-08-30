class Admin::LogosController < AdminController
  defaults :singleton => true
  belongs_to :show, :finder => :find_by_slug
end
