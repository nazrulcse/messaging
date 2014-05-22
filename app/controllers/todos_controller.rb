class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :edit, :update, :destroy]
  include ActionController::Live
  Mime::Type.register "text/event-stream", :stream

  # GET /todos
  # GET /todos.json
  def index
    respond_to do |format|
      format.html {
        @todos = Todo.all
      }
      format.stream {
        response.headers['Content-Type'] = 'text/event-stream'
        begin
          loop do
            Todo.uncached do
              response.stream.write "data: #{get_update_value}\n\n"
            end
            break
          end
        rescue IOError # Raised when browser interrupts the connection
        ensure
          response.stream.close # Prevents stream from being open forever
        end
      }
    end
  end

  # GET /todos/1
  # GET /todos/1.json
  def show
  end

  # GET /todos/new
  def new
    @todo = Todo.new
  end

  # GET /todos/1/edit
  def edit
  end

  # POST /todos
  # POST /todos.json
  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      if @todo.save
        format.html { redirect_to @todo, notice: 'Todo was successfully created.' }
        format.json { render :show, status: :created, location: @todo }
      else
        format.html { render :new }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1
  # PATCH/PUT /todos/1.json
  def update
    respond_to do |format|
      if @todo.update(todo_params)
        @todo.notification = 2
        @todo.save
        format.html { redirect_to @todo, notice: 'Todo was successfully updated.' }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1
  # DELETE /todos/1.json
  def destroy
    @todo.destroy
    respond_to do |format|
      format.html { redirect_to todos_url, notice: 'Todo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_update_value
    now = Time.now
    current_values = []
    todos = Todo.where('notification IS NULL OR notification = 2');
    todos.each do |todo|
      current_values << {description: todo.description, id: todo.id, status: todo.status, state: todo.notification}
      todo.notification = 1
      todo.save
    end
    current_values.to_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_params
      params.require(:todo).permit(:description, :status, :notification)
    end
end
