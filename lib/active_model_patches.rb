require 'active_model/serializers'

# Add monkey patch to ActiveModule::Errors to prevent marshal dumping from 
# generating the error of `can't dump hash with default proc`.
module ActiveModel
  class Errors
    def marshal_dump
      @messages.default_proc = @details.default_proc = nil
      [@messages, @details]
    end

    def marshal_load(data)
      @messages, @details = data

      @messages.default_proc = proc { |messags, attribute| messages[attribute] = [] }
      @details.default_proc = proc { |details, attribute| details[attribute] = [] }
    end
  end
end
