module ProMotion
  class MapScreenAnnotation < RMAnnotation
    attr_reader :params

    def initialize(params = {},map_view)
      @params = params
      @map_view = map_view
      set_defaults
      if @params[:coordinate]
        @params[:latitude] = @params[:coordinate].latitude
        @params[:longitude] = @params[:coordinate].longitude
        @coordinate = @params[:coordinate]
        initWithMapView(map_view, coordinate: @coordinate, andTitle: @params[:title])
      elsif @params[:latitude] && @params[:longitude]
        @coordinate = CLLocationCoordinate2D.new(@params[:latitude], @params[:longitude])
        initWithMapView(map_view, coordinate: @coordinate, andTitle: @params[:title])
      else
        PM.logger.error("You are required to specify :latitude and :longitude or :coordinate for annotations.")
        nil
      end
      self.userInfo = @params
    end
    
    def set_defaults
      if @params.class == Hash
        @params = {
          title: "Title",
          pin_color: :red,
          identifier: "Annotation-#{@params[:pin_color]}-#{@params[:image]}",
          show_callout: true,
          animates_drop: false,
          maki_icon: nil,
        }.merge(@params)
      elsif  @params.class == RMQuadTreeNode # Clustered pins 
        @params = {
          title: @params.annotations.count,
          coordinate: @params.clusterAnnotation.coordinate,
          pin_color: :purple,
          identifier: "Annotation-cluster",
          show_callout: true,
          animates_drop: false,
          maki_icon: nil,
        }
      end
    end

    def title
      @params[:title]
    end

    def subtitle
      @params[:subtitle] ||= nil
    end

    def coordinate
      @coordinate
    end
    
    def pin_color
      @params[:pin_color]
    end

    def cllocation
      CLLocation.alloc.initWithLatitude(@params[:latitude], longitude:@params[:longitude])
    end

    def setCoordinate(new_coordinate)
      super
      if new_coordinate.is_a? Hash
        @coordinate = CLLocationCoordinate2D.new(new_coordinate[:latitude], new_coordinate[:longitude])
      else
        @coordinate = new_coordinate
      end
    end
    
    def self.new_with_rmannotation(rmannotation,map_view)
      annotation = self.new(rmannotation.userInfo, map_view)
      %w(coordinate title subtitle userInfo annotationType annotationIcon 
      position layer clusteringEnabled 
      isClusterAnnotation isUserLocationAnnotation).each do |meth|
        annotation.send("#{meth}=", rmannotation.send(meth))
      end
      annotation
    end
    
    def method_missing(meth, *args)
      if @params[meth.to_sym]
        @params[meth.to_sym]
      else
        PM.logger.warn "The annotation parameter \"#{meth}\" does not exist on this pin."
        nil
      end
    end

  end
end
