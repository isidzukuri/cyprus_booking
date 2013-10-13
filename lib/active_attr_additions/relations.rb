module ActiveAttrAdditions

  module Relations
    extend ActiveSupport::Concern

    def marked_for_destruction?
      false
    end

    module ClassMethods

      def validates_associated(*attr_names)
        validates_with ActiveRecord::Validations::AssociatedValidator, _merge_attributes(attr_names)
      end

      def belongs_to(name)
        attr_accessor name
      end

      def nested_attribute(name, options={})
        is_plural = name.to_s.pluralize == name.to_s
        attribute name, :default => is_plural ? [] : nil

        relation_class = options[:class_name] ? options[:class_name].to_s.constantize : name.to_s.singularize.camelize.constantize

        define_method :"#{name}_attributes=" do |attributes|
          parent_var = self.class.name.underscore.to_sym
          if is_plural
            self.send("#{name}=", []) unless self.send(name)
            attributes.each do |attrs|
              inst = relation_class.new(attrs[1])
              inst.send("#{parent_var}=", self) if inst.respond_to?(parent_var)
              self.send(name) << inst
            end
          else
            inst = relation_class.new(attributes)
            inst.send("#{parent_var}=", self) if inst.respond_to?(parent_var)
            self.send("#{name}=", inst)
          end
        end

      end

    end

  end

end
