class HomePolicy < Struct.new(:user, :home)
  def home?
    true
  end
end
