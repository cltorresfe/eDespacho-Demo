<% if namespaced? -%>require_dependency "<%= namespaced_file_path %>/application_controller"<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  def index
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
  end

  def show
  end

  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
  end

  def edit
  end

  # POST <%= route_url %>
  # POST <%= route_url %>.js
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>

    respond_to do |format|
      if @<%= orm_instance.save %>
        format.html { redirect_to @<%= singular_table_name %>, notice: <%= "'#{human_name} ha sido creado correctamente.'" %> }
        format.js
      else
        format.html { render action: 'new' }
        format.js
      end
    end
  end
  # PUT <%= route_url %>/1
  # PUT <%= route_url %>/1.json
  def update
    respond_to do |format|
      if @<%= orm_instance.update("#{singular_table_name}_params") %>
        format.html { redirect_to @<%= singular_table_name %>, notice: <%= "'#{human_name} ha sido actualizado correctamente.'" %> }
        format.js
      else
        format.html { render action: 'edit' }
        format.js
      end
    end
  end

  # DELETE <%= route_url %>/1
  # DELETE <%= route_url %>/1.json
  def destroy
    @<%= orm_instance.destroy %>
    respond_to do |format|
      format.html { redirect_to <%= index_helper %>_url }
      format.js
    end
  end
  private
      # Use callbacks to share common setup or constraints between actions.
      def set_<%= singular_table_name %>
        @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
      end

      # Only allow a trusted parameter "white list" through.
      def <%= "#{singular_table_name}_params" %>
        <%- if attributes_names.empty? -%>
        params[<%= ":#{singular_table_name}" %>]
        <%- else -%>
        params.require(<%= ":#{singular_table_name}" %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
        <%- end -%>
      end
end
<% end -%>