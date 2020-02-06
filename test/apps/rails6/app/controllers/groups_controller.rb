class GroupsController < ApplicationController
  def new_group
    @group = Group.find params[:id]
    new_group = @group.dup
    new_group.save!
    redirect_to new_group
  end

  def safe_command_call
    value = Shellwords.escape(params[:value]) || nil
    Open3.capture2("stuff", "blah", value)
  end
end
