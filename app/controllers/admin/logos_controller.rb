class Admin::LogosController < AdminController
  defaults :singleton => true
  belongs_to :show
end
