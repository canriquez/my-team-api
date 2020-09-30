require 'rails_helper'

RSpec.describe Jobpost, type: :model do
  it { should have_many(:applications).dependent(:destroy) }
  it { should belong_to(:author)}
  #it { should have_many(:applicants).dependent(:destroy) }

  it { should validate_presence_of(:image)}
  it { should validate_presence_of(:enabled)}
  it { should validate_presence_of(:name)}

end
