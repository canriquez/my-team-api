module RequestSpecHelper
    # parse JSON into ruby hash
    def json 
        JSON.parse(response.body)
    end
end