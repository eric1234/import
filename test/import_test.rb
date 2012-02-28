require 'pathname'
$LOAD_PATH << Pathname.new(__FILE__).dirname.join('../lib')

require 'test/unit'

require 'rubygems'
require 'ruby-debug'
require 'flexmock/test_unit'

require 'import'

Import.logger = Logger.new(StringIO.new)

class ImportTest < Test::Unit::TestCase

  def test_import
    to = flexmock(To.new) do |mock|
      mock.should_receive(:create).with(10, {:name => 'bar'}).once
      mock.should_receive(:update).with(ToObj.new(10,  'food', 5), {:name => 'foo'}).once
      mock.should_receive(:destroy).with(ToObj.new(15,  'boo', 1)).once
    end
    to.import From.new
  end

  FromObj = Struct.new(:id, :name)
  class From < Import::Source
    def pull
      [
        FromObj.new(5,  'foo'),
        FromObj.new(10, 'bar'),
        FromObj.new(15, 'baz'),
      ]
    end

    def attributes(obj)
      {:name => obj.name}
    end

    def match_id(obj)
      obj.id
    end
  end

  ToObj = Struct.new(:id, :value, :fid)
  class To < Import::Source
    def pull
      [
        ToObj.new(10,  'food', 5),
        ToObj.new(15,  'boo', 1),
        ToObj.new(12, 'baz', 15),
      ]
    end

    def attributes(obj)
      {:name => obj.value}
    end

    def match_id(obj)
      obj.fid
    end
  end

end
