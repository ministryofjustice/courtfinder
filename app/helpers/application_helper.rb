module ApplicationHelper
  
  def link_to_add_fields(name, f, association, callback=nil)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    data = {id: id, fields: fields.gsub("\n", "")}
    data.merge!({callback: callback}) unless callback.nil?
    link_to(name, '#', class: "add_fields", data: data)
  end

  def admin_area?
    /(\/admin\/|\/admin$)/i =~ request.env['PATH_INFO']
  end
  
  def home_page?
    request.fullpath == '/'
  end
end
