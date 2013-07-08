class Host < ActiveRecord::Base

  belongs_to :site, :polymorphic => true

end
