require 'rails_helper'

RSpec.describe Todo, type: :model do
   "Testing associations"
  it { should have_many(:items).dependent(:destroy) }

   "Testing validations"
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:created_by) }
end
