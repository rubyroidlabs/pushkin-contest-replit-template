require 'json'
require 'net/http'
require 'retryable'

class Solver
  TOKEN='<YOUR_TOKEN_HERE>'
  ADDR=URI("http://pushkin-contest.ror.by/")

  def initialize
    @http = Net::HTTP.new(ADDR.host)
  end

  def call(env)
    if env["REQUEST_METHOD"] == "POST"
      params = JSON.parse(env["rack.input"].read)
      resolve(params)
    end

    [200, {"Content-Type" => "text/html"}, ["Hello World!"]]
  end

  def resolve(params)
    answer = 'HELLO WORLD!'
    #############################################################
    #
    #                    YOUR ALGORITHM HERE
    #
    #############################################################
    send_answer(answer, params["id"])
  end

  def send_answer(answer, task_id)
    retryable(tries: 3) do
      data = { answer: answer, token: TOKEN, task_id: task_id}
      @http.post('/quiz', data.to_json, {'Content-Type' =>'application/json'})
    end
  end
end
