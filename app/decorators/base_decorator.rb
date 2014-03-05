class BaseDecorator < Draper::Decorator
  delegate_all

  def self.inherited target
    target.send :prepend, ActiveCacher
  end
end
