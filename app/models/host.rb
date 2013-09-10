class Host < ActiveRecord::Base

  attr_accessible :name

  belongs_to :site, :polymorphic => true

end
