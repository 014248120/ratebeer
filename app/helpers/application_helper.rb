require 'action_view'
module ApplicationHelper 
  include ActionView::Helpers::NumberHelper

  def round(param)
    number_with_precision(param, precision:1, significant:false)
  end

  def edit_and_destroy_buttons(item)
    if current_user and current_user.admin
      edit = link_to('Edit', url_for([:edit, item]), class:'btn btn-warning')
      del = link_to('Destroy', item, method: :delete,
                    data: {confirm: 'Are you sure?' }, class:"btn btn-danger")
      raw("#{edit} #{del}")
    end
  end
end
