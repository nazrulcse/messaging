json.array!(@todos) do |todo|
  json.extract! todo, :id, :description, :status
  json.url todo_url(todo, format: :json)
end
