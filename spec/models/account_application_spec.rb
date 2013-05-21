require 'spec_helper'

describe AccountApplication do
  it { should belong_to :account }
  it { should belong_to :application }
  it { should validate_presence_of :account }
  it { should validate_presence_of :application }
end
