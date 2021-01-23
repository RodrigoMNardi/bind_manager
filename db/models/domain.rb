class Domain < ActiveRecord::Base
  validates :zone, presence: true, length: {maximum: 512}
  validates :mode, presence: true, length: {maximum: 512}
  validates :file, presence: true, length: {maximum: 512}
  validates :allow_transfer, presence: true, length: {maximum: 512}

  def to_bind9
    "
zone \"#{self.zone}\" {
  type #{self.mode};
  file \"#{self.file}\";
  allow-transfer { #{self.allow_transfer}; };
};"
  end
end
