require 'ostruct'

module FileUtility

  def FileUtility.build_records_in_struct_format(data, attributes)
    records = []
    data.each do |data|
      record = {}
      attributes.each_with_index do |attr, i|
        record["#{attr[0].downcase.to_sym}"] = data[i]
        record["oracle"] = data.last
      end
      records << OpenStruct.new(record)
    end
    records
  end

  def FileUtility.build_possible_values_for_attributes_hash(attributes)
    attrs = {}
    attributes.each do |a|
      attrs[a[0].downcase.to_sym] = a[1]
    end
    attrs
  end

  def FileUtility.read(path)
    possible_oracles = []
    attributes = []
    test_data = []

    File.open(path, "r").each_line do |line|

      data = line.split(" ")
      case data[0]
      when "T:"
          possible_oracles = data.drop(3)
      when "A:"
          attributes << ([data[1]] << data.drop(3))
      when "D:"
          test_data << data.drop(1)
      end
    end

    
    records = build_records_in_struct_format(test_data, attributes)
    attrs = build_possible_values_for_attributes_hash(attributes)

    return possible_oracles, attrs, records
  end

end