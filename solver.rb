require 'json'
require 'net/http'
require 'retryable'

class Solver
  TOKEN='3e81fe7c2ae2be50eb7b034ebb637c10'
  ADDR=URI("http://pushkin-contest.ror.by/")

  def initialize
    @http = Net::HTTP.new(ADDR.host)
  end

  def call(env)
    params = JSON.parse(env["rack.input"].read)
    resolve(params)

    [200, {"Content-Type" => "text/html"}, ["Hello World!"]]
  end

  def resolve(params)
    answer = 'HELLO WORLD!'
    #############################################################
    #
    #                     YOUR ALGORITHM HERE
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
