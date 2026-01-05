require 'csv'

module WcmcComponents
  module Loadable

    def self.included(base)
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module InstanceMethods
    end

    module ClassMethods
      def ignore_column(col_name)
        (@ignore_columns ||= {})[col_name.to_s] = true
      end

      def import_by(options)
        @import_by ||= {}
        options.each do |k, v|
          @import_by[k] = v
        end
      end



      def import file_name=nil, encoding=nil
        seed = csv_file_path file_name
        begin
          ActiveRecord::Base.transaction do
            # CSV.foreach(seed, headers: true, encoding:'iso-8859-1:utf-8') do |row|
            CSV.foreach(seed, headers: true, encoding: encoding) do |row|
              row_hash = row.to_h

              row_hash.except!(*@ignore_columns.keys) unless @ignore_columns.nil?

              # look up object for each belongs_to column - which property to join on can be set by
              # import_by: class_name: :property_name
              # and defaults to association_primary_key (usually id)
              belongs_to = reflections.select { |_key, hash| hash.macro == :belongs_to }

              belongs_to.each do |k, v|
                belongs_to_class = k.camelize.constantize

                # either  load by linked property e.g. id or name - here we need column name  to be class name
                if row_hash.key?(k)
                  join_key = @import_by[k.to_sym].to_s if (!@import_by.nil? && @import_by.key?(k.to_sym))
                  join_key ||= v.association_primary_key
                  owner = belongs_to_class.find_by(join_key => row_hash[k])
                else
                  # or load/create belongs_to object by columns starting with classname
                  # e.g. class_name,class_title etc.
                  belongs_to_hash = row_hash.find_all { |col, _val| col.starts_with?("#{k}_") }.to_h

                  # remove these keys from the main class hash
                  row_hash.except!(*belongs_to_hash.keys)

                  # strip the class_ from front of keys
                  belongs_to_hash.transform_keys! { |key| key.remove k+"_"}
                  owner = belongs_to_class.find_or_create_by!(belongs_to_hash) unless belongs_to_hash.empty?
                end
                row_hash[k] = owner
              end

              # look up objects for each HABTM and has_many column - assumes column name is pluralised class name
              many_associations = reflections.select { |_key, hash| hash.macro == :has_and_belongs_to_many || hash.macro == :has_many }

              # many_associations columns need adding later, so exclude them (and their singularized versions)
              create_cols = row_hash.except(*many_associations.keys)
              create_cols = create_cols.except(*many_associations.keys.map(&:singularize))

              new_object = find_or_create_by!(create_cols)

              # now look up the many_associations which should be semi-colon separated values
              many_associations.each do |k, v|
                # check if the many_associations relationship is in this csv - and is it singular or plural in the header
                if row.headers.include?(k) && !row_hash[k].nil?
                  col_name = k
                elsif row.headers.include?(k.singularize) && !row_hash[k.singularize].nil?
                  col_name = k.singularize
                else
                  next
                end
                
                list_of_children = row_hash[col_name].split(';')

                list_of_children.each do |child_name|
                  next if child_name.blank?
                  # I've strip'd whitespace from start/end as csv's are often inconsistently white-spaced
                  join_key = @import_by[k.to_sym].to_s if (!@import_by.nil? && @import_by.key?(k.to_sym))
                  join_key ||= v.association_primary_key
                  
                  new_child = k.camelize.singularize.constantize.find_or_create_by(join_key => child_name.strip)
                  
                  unless new_object.send(k.downcase.to_sym).exists?(new_child.id)
                    new_object.send(k.downcase.to_sym) << new_child
                  end
                end
              end

            end
          end
        rescue => e
          puts e
          Rails.env.development? ? byebug : Rails.logger.error(e)
        end
      end
      
      def csv_file_path(base_file_name = nil)
        base_file_name ||= "#{to_s.pluralize.downcase}.csv"
        Rails.env.test? ?
          Rails.root.join('test', 'seeds', base_file_name) :
          Rails.root.join('lib', 'data', 'seeds', base_file_name)
      end
    end

  end
end
