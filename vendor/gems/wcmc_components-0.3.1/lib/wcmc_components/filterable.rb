module WcmcComponents
  module Filterable
    def self.included base
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module InstanceMethods
    end

    module ClassMethods
      # declare attrs you want to filter on
      def table_attr(attr, options = {})
        (@table_attrs ||= {})[attr] = options
      end

      def filters
        table_attrs.select { |_k, v| v[:filter_on] } || {}
      end

      def table_cols
        table_attrs.select { |_k, v| v[:show_in_table] } || {}
      end

      def legends
        table_attrs.select { |_k, v| v[:legend_on] } || {}
      end

      def table_cols_and_modal_items
        table_attrs.select { |_k, v| v[:show_in_table] || v[:show_in_modal] } || {}
      end

      def csv_items
        table_attrs.select do |_k, v|
          if v[:show_in_csv] == true
            true
          elsif v[:show_in_csv] == false
            false
          else
            v[:show_in_table] || v[:show_in_modal]
          end
        end || {}
      end

      def table_attrs
        @table_attrs ||= {}
      end

      # this currently supports "filters" and "legends" passed as params in controller

      def attributes_to_json(attributes)
        full_list = self.all.order(id: :asc)
        attributes == "legends" ? attributes = legends : attributes = filters
        attributes_array = []
        attributes.each do |key, attribute|
        case attribute[:type]
        when "single"
          attributes_array << { 
            name: key.to_s,
            title: attribute[:title] || key.to_s.capitalize,
            options: full_list.pluck(key).compact.uniq.sort,
            type: attribute[:type]
          }
        when "multiple"
          options_array = self.all.preload(key).collect(&key).flatten.uniq.map(&:name) || []
          attributes_array << {
            name: key.to_s,
            title: attribute[:title] || key.to_s.capitalize,
            options: options_array.sort,
            type: attribute[:type]
          }
          end
        end
        attributes_array.to_json
      end

      def all_to_json
        json = self.all.order(id: :asc).to_a.map! do |item|
          item_j = {
            id: item.id
          }

          table_attrs.each_key do |col|
            item_j[col.to_s] = item.send(col)
          end

          item_j
        end.to_json
      end

      def all_to_csv
        json = self.all.order(id: :asc).to_a.map! do |item|
          item_j = {
            id: item.id
          }

          table_attrs.each_key do |col|
            item_j[col.to_s] = item[col]
          end

          item_j
        end.to_json
      end

      def to_csv(json)
        json_params = json.nil? ? nil : JSON.parse(json)
        filter_params = get_filter_params(json_params)

        items = query_with_filters(filter_params)

        csv_string = CSV.generate(encoding: 'UTF-8') do |csv_line|
          
          # build headers for CSV from the column titles on the page
          headers = ['Id']
          csv_items.each do |key,col|
            headers << col[:title]
          end
          csv_line << headers.flatten

          # build each row for CSV - matching 'value:' in the filter table
          items.each do |item|
            row = []
            row << item.id
            csv_items.each do |key,col|
              case col[:type]
              when "single"
                row << item.send(key)
              when "multiple"
                row << item.send(key.to_s.pluralize).map(&:name).join('; ')
              end
            end
            csv_line << row
          end
        end
      end
      
      def filter_table(items)
        items.map! do |item|
          item_j = {
            pageUrl: show_page_path(item),
            cells: []
          }

          item_j[:cells] << {
            name: 'id',
            title: 'Id',
            value: item.id,
            showInTable: false,
            showInModal: false,
          }
          # title and values also used in to_csv() to generate a CSV so if making changes here, also look there!
          table_cols_and_modal_items.each do |key, col|
            case col[:type]
            when "single"
              item_j[:cells] << {
                name: key.to_s,
                title: col[:title],
                value: item.send(key),
                showInTable: col[:show_in_table],
                showInModal: col[:show_in_modal],
                legend_on: col[:legend_on]
              }
            when "multiple"
              item_j[:cells] << {
                name: key.to_s,
                title: col[:title],
                value: item.send(key.to_s.pluralize).map(&:name),
                showInTable: col[:show_in_table],
                showInModal: col[:show_in_modal],
                legend_on: col[:legend_on]
              }
            end
          end
          item_j
        end
      end

      def show_page_path(item)
        return nil if WcmcComponents.classes_show_page_format.nil?

        format = WcmcComponents.classes_show_page_format[to_s]

        return nil if format.nil?

        format % item.id
      end

      def columns_to_json
        columns = []
        table_cols.keys.each do |col|
          columns << {field: col,
                      title: table_cols[col][:title] || col.to_s.gsub(/_/,' ').capitalize}
        end
        columns.to_json
      end

      def paginate(json)
        json_params = json.nil? ? nil : JSON.parse(json)
        current_page = get_page(json_params)
        items_per_page = get_items_per_page(json_params)
        
        filter_params = get_filter_params(json_params)

        items = query_with_filters(filter_params)
        {
          current_page: current_page,
          per_page: items_per_page,
          total_entries: entries(items),
          total_pages: pages(items, items_per_page),
          items: filter_table(items.slice((current_page - 1) * items_per_page, items_per_page))
        }
      end

      def get_page(json_params)
        if json_params.present? && json_params['requested_page'].present?
          json_params['requested_page'].to_i
        else
          1
        end
      end

      def get_items_per_page(json_params)
        if json_params.present? && json_params['items_per_page'].present?
          json_params['items_per_page'].to_i
        else
          10
        end
      end

      def get_filter_params(json_params)
        if json_params.present? && json_params['filters'].present?
          filter_params = json_params['filters'].all? { |p| p['options'].blank? } ? [] : json_params['filters']
        else
          []
        end
      end


      def entries(items)
        items.count
      end

      def pages(items, items_per_page)
        return 0 if items.count == 0

        items.each_slice(items_per_page).count
      end

      def sql_from_filters(filters)
        params = {}
        filters.each do |filter|
          next if filter['options'].count == 0
          # TO-DO this may throws error if there are string  names with apostrophes 
          options = filter['options'].map{ |v| "'#{v}'" }
          name = filter['name']
          # collect params for different filter types
          if filter['type'] == "multiple"
          # this assumes we join and filter on the name column of the habtm property - true for tool navigator, maybe not in general
            params[name] = "#{filter['name']}.name IN (#{options.join(',')})"
          # else if its a string
          else
            params[name] = "#{self.table_name}.#{name} IN (#{options.join(',')})"
          end 
        end
        params.compact
      end

      def query_with_filters (filters)
        where_params = sql_from_filters(filters)
        # which filters are habtms? and do their options have any values?
        habtm_filters = filters.select {|f| f['type'] == "multiple" && f['options'].any? }
        # if yes hbtm(s) join
        if habtm_filters.any?
          habtm_tables = []
          habtm_filters.each do |filter|
            habtm_tables << filter['name'].parameterize.underscore.to_sym
          end
          joins(habtm_tables).where(where_params.values.join(' AND ')).order('id ASC').to_a
        else
          where(where_params.values.join(' AND ')).order('id ASC').to_a
        end
      end
    end
  end
end
