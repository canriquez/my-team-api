module Response
    def json_response(onject, status = :ok)
        render json: object, status: status
    end
end