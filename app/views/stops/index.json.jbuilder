json.array! @stops do |stop|
	json.stopNumber stop.stop_number
	json.name stop.name

	json.location do
		json.lat stop.lat
		json.lng stop.lng
	end
end
# json.partial! partial: 'public', collection: @stops, as: :stop