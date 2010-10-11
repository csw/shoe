require 'test/helper'

class RakeTestTest < Shoe::TestCase
  describe 'rake test' do
    it 'is active only if there are test files present' do
      assert_no_task 'test'
      add_files_for_test
      assert_task 'test'
    end

    it 'runs tests' do
      add_files_for_test
      system 'rake test'
      assert_match '1 tests, 1 assertions, 0 failures, 0 errors', stdout
    end

    it 'depends (perhaps indirectly) on rake compile' do
      add_files_for_c_extension
      add_files_for_test 'require "foo/extension"'
      system 'rake test'
      assert_match '1 tests, 0 assertions, 0 failures, 0 errors', stdout
    end
  end
end
