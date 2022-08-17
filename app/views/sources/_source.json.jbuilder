json.extract! source, :id, :url, :album_id, :service_id, :created_at, :updated_at
json.url source_url(source, format: :json)
