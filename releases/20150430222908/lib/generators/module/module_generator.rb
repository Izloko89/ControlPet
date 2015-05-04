class ModuleGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  argument :module_child_name, :type => :string, :default => 'items'


  def copy_module_files

    # Model
    template "models/module.erb", "app/models/#{parent_name.singularize}.rb"
    # Controller
    template "controllers/module_controller.erb", "app/controllers/#{parent_name}_controller.rb"

    directory "views/module/", "app/views/#{parent_name}/"

    if child_name == 'items'

    else
      directory "views/module_child/", "app/views/#{child_name}/"
    end

  end

  private
  	def parent_name
  		file_name.underscore
  	end

    def parent_model_name
      file_name.singularize.camelize
    end

    def parent_controller_name
      file_name.camelize
    end



  	def child_name
  		module_child_name.underscore
  	end

    def child_model_name
      module_child_name.singularize.camelize
    end

    def child_controller_name
      module_child_name.camelize
    end


end
