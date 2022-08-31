# rails c
# load 'lib/io/import.rb'

# CSV must by shrunk

require 'csv'
rows = CSV.parse(File.read('lib/io/recommendations.csv'), headers: true)
bad_rows = []

rows.each_with_index do |row, i|
  if row['Artist'].length > 0 && row['Album'].length > 0
    # based on RecommendationsController#create ... should we just use that??
    artist = Artist.find_or_create_by(name: row['Artist'])
    album = Album.find_or_create_by(name: row['Album'], artist_id: artist.id)
  else
    bad_rows << "index #{i}: #{row['Artist']}: #{row['Album']}"
  end
end

bad_rows.each do |row|
  puts(row)
end
