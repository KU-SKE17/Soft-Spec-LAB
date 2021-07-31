class PoliteValidator < ActiveModel::EachValidator

    def validate_each(object, attribute, value)
        if value.to_s.downcase.include?('bad')
            object.errors.add(attribute, 'cannot contain bad words')
        end
    end
end