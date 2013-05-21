require 'spec_helper'

describe Application do
  it { should validate_presence_of :name }
  it { should have_many :account_applications }
end
