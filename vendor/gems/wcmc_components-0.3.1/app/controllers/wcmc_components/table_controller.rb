module WcmcComponents
  class TableController < ApplicationController

    def table_class
      # walk up url to find which class table we are in
      path = request.fullpath
      while !path.nil?
        if !WcmcComponents.routes_classes[path].nil?
          return WcmcComponents.routes_classes[path].constantize
        elsif !path.rindex('/').nil?
          path = path[0, path.rindex('/')+1]
        else
          return nil
        end
      end
    end
    
    def list
      @results = table_class.paginate(params.to_json)
      render json: @results
    end

    def download
      send_data table_class.to_csv(params.to_json), {
                  type: "text/csv; charset=utf-8; header=present",
                  disposition: "attachment",
                  filename: "filtered-indicators.csv" }
    end

  end
end
