class Import::Source

  # Will import the data from master into self. Is mostly just a
  # wrapper around the instance version of import so you can say:
  #
  #     FooInc.import BarCorp
  #
  # instead of:
  #
  #     FooInc.new.import BarCorp.new
  def self.import(master)
    new.import master.new
  end

  # Will import the data from master
  def import(master)
    # Spin out retrieval and processing of data
    to = Thread.new {Thread.current['ret'] = all}
    from = Thread.new {Thread.current['ret'] = master.all}

    # Wait until everything is ready to compare and get results
    to = to.join['ret']
    from = from.join['ret']

    # Figure out what is new, getting updated and getting removed
    new = from.keys.reject {|id| to.keys.include? id}.inject({}) {|m, id| m[id] = from[id]; m}
    remove = to.keys.reject {|id| from.keys.include? id}
    existing = from.reject {|id, attrs| new.has_key?(id) || to[id] == from[id]}

    # Actually carry out actions
    new.each do |id, attrs|
      Import.logger.info "Creating #{id} with #{attrs.inspect}"
      create id, attrs
    end
    existing.each do |id, attrs|
      Import.logger.info "Updating #{id} with #{attrs.inspect}"
      update data[id], attrs
    end
    remove.each do |id|
      Import.logger.info "Removing #{id}"
      destroy data[id]
    end
  end

  # Pull data, extract attributes and index by foreign id
  def all
    data.keys.inject({}) {|m, id| m[id] = attributes(data[id]); m}
  end

  private

  # Like pull but memoized and indexed by match_id
  def data
    @data ||= pull.inject({}) {|m,r| m[match_id(r)] = r; m}
  end

end
