require 'test/unit'
require 'bayesian_learn'

class TestBayesianTree < Test::Unit::TestCase
  def test_hello_world
    assert_equal 'hello world', BayesianLearn.train(['ds', 'ff', 'fdf'])
  end
end

