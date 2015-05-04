json.array!(@sales) do |sale|
  json.extract! sale, 
  json.url sale_url(sale, format: :json)
end
