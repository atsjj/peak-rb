require 'test_helper'

class PeakTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Peak::VERSION
  end
end
