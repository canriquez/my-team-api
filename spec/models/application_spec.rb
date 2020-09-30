require 'rails_helper'

RSpec.describe Application, type: :model do
  it { should have_many(:likes).dependent(:destroy) }
  it { should belong_to(:applicant) }
  it { should belong_to(:jobpost) }
end
