require 'json'
require 'net/http'
require 'retryable'

class Solver
  TOKEN='<YOUR_TOKEN_HERE>'
  ADDR=URI("https://pushkin-contest-hexlet.rubyroidlabs.dev/")

  def initialize
    @http = Net::HTTP.start(ADDR.host, ADDR.port, use_ssl: true)
  end

  def call(env)
    if env["REQUEST_METHOD"] == "POST"
      params = JSON.parse(env["rack.input"].read)
      resolve(params)
    end

    [200, {"Content-Type" => "text/html"}, ["Hello World!"]]
  end

  def resolve(params)
    answer = '<NO_ANSWER_YET>'
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
