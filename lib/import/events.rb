# rails c
# load 'lib/import/events.rb'


# CSV MUST BE SHRUNK!!!!

require 'csv'
rows = CSV.parse(File.read('lib/import/events.csv'), headers: true)
bad_rows = []




rows.each_with_index do |row, i|
  if row['Artist'].length > 0 && row['Album'].length > 0 && row['Date'].length
    artist = Artist.find_or_create_by(name: row['Artist'])
    album = Album.find_or_create_by(name: row['Album'], artist_id: artist.id)

    event = Event.find_or_create_by(
      name: 'Album Listening night ' + row['Date'],
      started_at: Date.strptime(row['Date'], '%m/%d/%Y')
    )
    
    Play.find_or_create_by(album_id: album.id, event_id: event.id)
  else
    bad_rows << "index #{i}: #{row['Artist']}: #{row['Album']}"
  end
end

bad_rows.each do |row|
  puts(row)
end
