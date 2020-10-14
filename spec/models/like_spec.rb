require 'rails_helper'

RSpec.describe Like, type: :model do
  it { should belong_to(:admin) }
  it { should belong_to(:application) }

  it { should validate_presence_of(:evaluation) }
end
