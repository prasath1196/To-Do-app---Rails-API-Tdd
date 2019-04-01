require 'rails_helper'

RSpec.describe Item, type: :model do
  "Testing association"
  it { should belong_to(:todo) }
  "Testing Validations"
  it { should validate_presence_of(:name) }
end
