class Versions::DescriptionVersion < Version
  include HTMLDiff

  def fix_state
    self.state = measure_changes.enough? ? 'accepted' : 'taken'
    save if changed?
  end

private

  def measure_changes
    MeasureChanges.new item_diff['description_ru'][0], item_diff['description_ru'][1]
  end

  def takeable?
    true
  end
end
