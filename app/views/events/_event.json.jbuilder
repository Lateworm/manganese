json.extract! event, :id, :name, :started_at, :created_at, :updated_at
json.url event_url(event, format: :json)
