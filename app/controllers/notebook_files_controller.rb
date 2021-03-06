class NotebookFilesController < NotebookItemsController
  helper :political_notebooks

  def create
    return false unless @can_edit

    @file = NotebookFile.new(params[:notebook_file])
    @file.political_notebook = @political_notebook
    @success = @file.save
    @item = @file

    respond_to do |format|
      format.js {
        responds_to_parent {
          render :update do |page|
            if @success
              page << "NotebookForm.hideAllForms();"
              page.insert_html(:top, "notebook-items", :partial => "notebook_files/listitem", :object => @file)
            else
              page.alert(@file.errors.full_messages.to_sentence)
            end
          end
        }
      }
      format.html {
        redirect_to group_path(@political_notebook.group) unless @political_notebook.group.nil?
      }
    end
  end

  def show
    if @can_view
      file = NotebookFile.find(params[:id])
      send_file file.filesytem_path, :type => file.content_type, :disposition => file.image? ? 'inline' : 'attachment'
    else
      render :text => "You don't have permission to view this file"
    end
  end

end