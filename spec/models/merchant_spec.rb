require 'rails_helper'

RSpec.describe Merchant do
  it { should have_many :items }
end
