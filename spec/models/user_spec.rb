require 'rails_helper'

RSpec.describe User, type: :model do

  it { should have_many(:authored_posts).dependent(:destroy) }
  it { should have_many(:liked_applications).dependent(:destroy) }
  it { should have_many(:applications).dependent(:destroy) }
  
  it { should have_many(:applied_jobs).dependent(:destroy) }

  it { should validate_presence_of(:email)}
  it { should validate_presence_of(:name)}
  it { should validate_presence_of(:role)}
  it { should validate_presence_of(:avatar)}

end
