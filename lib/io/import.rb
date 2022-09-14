# rails c
# load 'lib/io/import.rb'

# CSV MUST BE SHRUNK!!!!
# TODO: trim whitespace off all fields
# TODO: validate URLs
# TODO: find duplicates / data clenaup suite

require 'csv'
rows = CSV.parse(File.read('lib/io/recommendations.csv'), headers: true)
bad_rows = []

rows.each_with_index do |row, i|
  if row['Artist'].length > 0 && row['Album'].length > 0 && row['Spotify'].length
    artist = Artist.find_or_create_by(name: row['Artist'])
    album = Album.find_or_create_by(name: row['Album'], artist_id: artist.id)
    recommendation = Recommendation.find_or_create_by(album_id: album.id, user_id: nil, user_name: row['Username'])
    spotify = Service.find_or_create_by(name: 'Spotify');
    spotify_source = Source.find_or_create_by(service_id: spotify.id, album_id: album.id, url: row['Spotify'])
  else
    bad_rows << "index #{i}: #{row['Artist']}: #{row['Album']}"
  end
end

bad_rows.each do |row|
  puts(row)
end
