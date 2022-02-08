require 'rails_helper'

RSpec.describe Item do
  it { should belong_to :merchant }
end
