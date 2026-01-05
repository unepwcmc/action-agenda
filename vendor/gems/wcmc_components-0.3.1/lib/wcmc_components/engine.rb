module WcmcComponents
  mattr_accessor :routes_classes
  mattr_accessor :classes_show_page_format

  class Engine < ::Rails::Engine
    isolate_namespace WcmcComponents
  end
end
